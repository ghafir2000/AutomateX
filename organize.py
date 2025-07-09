import os
import shutil

# --- Configuration ---
# The directory where all the messy files are currently located.
# '.' means the current directory where you run the script.
SOURCE_DIR = '.'

# Names for the new destination folders.
LARAVEL_DIR = 'backend-laravel'
FLUTTER_DIR = 'frontend-flutter'
LOST_AND_FOUND_DIR = 'Lost_And_Founds'

# --- File and Folder Categorization (based on your image) ---

# Category 1: Items to move into the Laravel backend folder.
laravel_items = [
    'app', 'bootstrap', 'config', 'database', 'public', 'resources',
    'routes', 'storage', 'tests', 'vendor', 'artisan', 'composer.json',
    'composer.lock', 'package.json', 'package-lock.json', 'vite.config.js',
    'phpunit.xml', '.editorconfig', '.env', '.env.copy.example', '.htaccess'
]

# Category 2: Items to move into the Flutter frontend folder.
flutter_items = [
    'android', 'ios', 'lib', 'linux', 'macos', 'test', 'web',
    'analysis_options.yaml', 'pubspec.lock', 'pubspec.yaml', '.metadata'
]

# Category 3: Ambiguous, user-specific, or items needing manual review.
lost_and_found_items = [
    '.vscode',              # Editor settings, can be configured for multi-root workspace later.
    'node_modules',         # Best to delete and reinstall inside 'backend-laravel' via `npm install`.
    'AutomateX',            # Custom folder, likely belongs to one of the projects.
    'Font',                 # Custom assets, likely for the frontend.
    'images',               # Custom assets, likely for the frontend.
    'app.rar',              # Archive, needs manual inspection.
    'images.zip'            # Archive, needs manual inspection.
]

# Items to LEAVE in the root directory.
do_not_move = [
    '.git',
    '.gitignore',
    '.gitattributes',
    'README.md',
    os.path.basename(__file__) # Don't move the script itself!
]

# --- Main Script Logic ---

def organize_project_files():
    """
    Creates new directories and moves files/folders based on the categories defined above.
    """
    print("Starting project organization...")

    # Create destination directories if they don't exist
    laravel_path = os.path.join(SOURCE_DIR, LARAVEL_DIR)
    flutter_path = os.path.join(SOURCE_DIR, FLUTTER_DIR)
    lost_and_found_path = os.path.join(SOURCE_DIR, LOST_AND_FOUND_DIR)

    os.makedirs(laravel_path, exist_ok=True)
    os.makedirs(flutter_path, exist_ok=True)
    os.makedirs(lost_and_found_path, exist_ok=True)

    # Combine all items into a single dictionary for easier lookup
    all_items_map = {
        **{item: laravel_path for item in laravel_items},
        **{item: flutter_path for item in flutter_items},
        **{item: lost_and_found_path for item in lost_and_found_items}
    }

    # Get a list of all items in the source directory
    items_in_source = os.listdir(SOURCE_DIR)

    for item_name in items_in_source:
        # Skip the destination folders and items we want to leave in root
        if item_name in [LARAVEL_DIR, FLUTTER_DIR, LOST_AND_FOUND_DIR] or item_name in do_not_move:
            continue

        source_item_path = os.path.join(SOURCE_DIR, item_name)

        if item_name in all_items_map:
            destination_path = all_items_map[item_name]
            try:
                print(f"Moving '{item_name}' to '{os.path.basename(destination_path)}/'...")
                shutil.move(source_item_path, destination_path)
            except Exception as e:
                print(f"  ERROR moving '{item_name}': {e}")
        else:
            print(f"WARNING: Unrecognized item '{item_name}'. Leaving it in the root directory.")

    print("\nOrganization complete!")
    print(f"Please review the contents of the '{LOST_AND_FOUND_DIR}' folder and move items manually.")
    print("Remember to update your .gitignore paths if necessary.")

if __name__ == "__main__":
    # Safety check
    print("This script will move files and folders in the current directory.")
    print("It's highly recommended to make a backup of your project first.")
    confirm = input("Are you sure you want to continue? (yes/no): ")

    if confirm.lower() == 'yes':
        organize_project_files()
    else:
        print("Operation cancelled.")