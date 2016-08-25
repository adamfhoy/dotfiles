import argparse
import difflib
import os
from shutil import copyfile
import sys


CONFIG_FILES = [".bashrc", ".vimrc", ".tmux.conf", ".tmux/dev_env",]
HOME_DIR = ''
GIT_DIR = ''

def build_parser():
    description_str = ("Compares local machine dotfiles to git repo dotfiles, "
                       "giving option to update")
    parser = argparse.ArgumentParser(prog="update_configs.py",
            usage="%(prog)s [options]", add_help=False,
            description=description_str
            )
    parser.add_argument("-h", "--help", action="help",
                        help="Show this help message and exit")

    group = parser.add_mutually_exclusive_group()
    group.add_argument(
            "-Y", "--replace-local",
            dest="update_all_files",
            action="store_true",
            help="Update all config files without prompting.")
    group.add_argument(
            "-d", "--diff-only",
            dest="show_diffs_only",
            action="store_true",
            help="Show config differences, but don't update")

    parser.add_argument("--git_dotfiles_dir", dest="git_dotfiles_dir",
            default=None, help="root directory for config files from git.")
    parser.add_argument("--home_dotfiles_dir", dest="home_dotfiles_dir",
            default=None, help="root directory for local config files.")
    return parser

def setup_file_paths(args):
    if args.home_dotfiles_dir:
        homedir = args.home_dotfiles_dir
        home_str = "given home directory %s" % homedir
    else:
        homedir = os.path.expanduser("~")
        home_str = "your home directory %s" % homedir
    global HOME_DIR
    HOME_DIR = homedir
    homedir_filename_str = '%s/%s' % (homedir, '%s')

    if args.git_dotfiles_dir:
        gitdir = os.path.abspath(args.git_dotfiles_dir)
        git_str = "the given git directory %s." % gitdir
        gitdir_filename_str = '%s/%s' % (gitdir, '%s')
    else:
        gitdir = os.getcwd()
        git_str = "the current working directory %s." % gitdir
        gitdir_filename_str = '%s/%s' % (gitdir, '%s')
    global GIT_DIR
    GIT_DIR = gitdir

    print("Comparing config files in %s to files in %s") % (home_str, git_str)
    return homedir_filename_str, gitdir_filename_str

def get_changed_configs(args):
    homedir_filename_str, gitdir_filename_str = setup_file_paths(args)
    unchanged_configs = []
    changed_configs = []

    for config in CONFIG_FILES:
        config_diff = get_config_diff(config, homedir_filename_str,
                                      gitdir_filename_str)
        if config_diff:
            changed_configs.append((config, config_diff))
        else:
            unchanged_configs.append(config)
    return (unchanged_configs, changed_configs)

def get_config_diff(config_filename, homedir_filename_str,
                  gitdir_filename_str):
    homedir_filename = os.path.join(HOME_DIR, config_filename)
    gitdir_filename = os.path.join(GIT_DIR, config_filename)
    with open(homedir_filename, 'r') as home_file, \
         open(gitdir_filename, 'r') as git_file:

        files_diff = difflib.unified_diff(
            home_file.readlines(), git_file.readlines(),
            fromfile=homedir_filename, tofile=gitdir_filename,
            n=0)
        readable_diff = ('\n'.join(files_diff))

        if not(readable_diff):
            return None
        else:
            return readable_diff

def query_user(question, prompt, responses_dict, default="no"):
    if default not in responses_dict:
        raise ValueError("Invalid default user choice: '%s'" % default)
    sys.stdout.write(question + '\n')
    sys.stdout.write(prompt)
    while True:
        choice = raw_input().lower()
        if default is not None and choice == '':
            print
            return responses_dict[default]
        elif choice in responses_dict:
            print
            return responses_dict[choice]
        else:
            print("Please respond with one of the given options:")
            sys.stdout.write(prompt)

def query_further_action(changed_config_tuples_list):
    update_now_str = (
            "Would you like to interactively [s]elect files to update,\n"
            "update [a]ll files with differences, [d]isplay differences\n"
            "only, or [e]xit?")
    select_prompt = "[Select | All | Display | Exit]:"
    response_options_dict = {"select": "select", "s": "select",
                             "exit": "exit", "ex": "exit", "e": "exit",
                             "all": "all", "a": "all",
                             "display": "display", "d": "display",}
    response = query_user(update_now_str, select_prompt,
                          response_options_dict, default="exit")
    if response == "select":
        update_configs_list = query_files_to_update(
                changed_config_tuples_list)
        replace_files(update_configs_list)
    elif response == "all":
        unzipped_updated = zip(*changed_config_tuples_list)
        replace_files(unzipped_updated[0])
    elif response == "display":
        display_diffs(changed_config_tuples_list)
    elif response == "exit":
        return
    else:
        print("Error, invalid selection, exiting")

def query_files_to_update(changed_tuples):
    update_file_str = "Update %s? Select [S]how to see diff."
    update_prompt = "[Yes | No | Show]:"
    update_responses_dict = {"yes": "yes", "y": "yes",
                             "no": False, "n": False,
                             "show": "show", "s": "show"}
    accept_file_str = "Update %s?."
    accept_prompt = "[Yes | No ]:"
    accept_responses_dict = {"yes": True, "y": True,
                             "no": False, "n": False,}
    config_files_to_update = []
    for (config, diff) in changed_tuples:
        response = query_user((update_file_str % config), update_prompt,
                update_responses_dict, default="no")
        if response == "yes":
            config_files_to_update.append(config)
        elif response == "show":
            display_diff(config, diff)
            if query_user((accept_file_str % config), accept_prompt,
                    accept_responses_dict, default="no"):
                config_files_to_update.append(config)
    return config_files_to_update

def display_diffs(changed_tuples_list):
    for (config, diff) in changed_tuples_list:
        display_diff(config, diff)

def display_diff(config, diff):
    print("Diff file for %s" % config)
    print(diff)
    print

def replace_files(config_files_list):
    backup_dir = os.path.join(HOME_DIR, 'dotfiles_backup')
    if not os.path.isdir(backup_dir):
        print "Backup directory %s does not exist, creating." % backup_dir
        os.makedirs(backup_dir)
    for config_file in config_files_list:
        target_file = os.path.join(HOME_DIR, config_file)
        source_file = os.path.join(GIT_DIR, config_file)
        backup_file = os.path.join(backup_dir, config_file)

        copyfile(target_file, backup_file)
        copyfile(source_file, target_file)
        print "Original file backed up to %s" % backup_file
        print "Updated: %s" % target_file
        print

def main():
    parser = build_parser()
    args = parser.parse_args()
    unchanged_configs, changed_configs = get_changed_configs(args)

    if not changed_configs:
        print("All config files are up to date.")
        return

    if unchanged_configs:
        print("The following config files are up to date:")
        for config_filename in unchanged_configs:
            print("\t%s" % config_filename)
    if changed_configs:
        print("The following config files differ and need to be updated on "
              "this machine:")
        for (config_filename, config_diff) in changed_configs:
            print("\t%s" % config_filename)
        print

        if args.update_all_files:
            print("Updating all home directory files to match gitdir files "
                  "due to -Y flag")
            unzipped_changed = zip(*changed_configs)
            replace_files(unzipped_changed[0])
        else:
            query_further_action(changed_configs)
            print("Exiting")

if __name__ == "__main__":
    main()
