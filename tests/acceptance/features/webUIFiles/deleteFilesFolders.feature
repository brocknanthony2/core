@webUI @insulated @disablePreviews
Feature: deleting files and folders
As a user
I want to delete files and folders
So that I can keep my filing system clean and tidy

	Background:
		Given a regular user has been created
		And the regular user has logged in using the webUI
		And the user has browsed to the files page

	Scenario: Delete files & folders one by one and check its existence after page reload
		When the user deletes the following elements using the webUI
		| name                                |
		| simple-folder                       |
		| lorem.txt                           |
		| strängé नेपाली folder                  |
		| strängé filename (duplicate #2 &).txt |
		Then the deleted elements should not be listed on the webUI
		And the deleted elements should not be listed on the webUI after a page reload

	Scenario: Delete a file with problematic characters
		When the user renames the following file using the webUI
			| from-name-parts | to-name-parts   |
			| lorem.txt       | 'single'        |
			|                 | "double" quotes |
			|                 | question?       |
			|                 | &and#hash       |
		And the user reloads the current page of the webUI
		Then the following file should be listed on the webUI
			| name-parts      |
			| 'single'        |
			| "double" quotes |
			| question?       |
			| &and#hash       |
		And the user deletes the following file using the webUI
			| name-parts      |
			| 'single'        |
			| "double" quotes |
			| question?       |
			| &and#hash       |
		Then the following file should not be listed on the webUI
			| name-parts      |
			| 'single'        |
			| "double" quotes |
			| question?       |
			| &and#hash       |
		When the user reloads the current page of the webUI
		Then the following file should not be listed on the webUI
			| name-parts      |
			| 'single'        |
			| "double" quotes |
			| question?       |
			| &and#hash       |

	Scenario: Delete multiple files at once
		When the user batch deletes these files using the webUI
		| name          |
		| data.zip      |
		| lorem.txt     |
		| simple-folder |
		Then the deleted elements should not be listed on the webUI
		And the deleted elements should not be listed on the webUI after a page reload

	Scenario: Delete an empty folder
		When the user creates a folder with the name "my-empty-folder" using the webUI
		And the user creates a folder with the name "my-other-empty-folder" using the webUI
		And the user deletes the folder "my-empty-folder" using the webUI
		Then the folder "my-other-empty-folder" should be listed on the webUI
		But the folder "my-empty-folder" should not be listed on the webUI

	Scenario: Delete the last file in a folder
		When the user deletes the file "zzzz-must-be-last-file-in-folder.txt" using the webUI
		Then the file "zzzz-must-be-last-file-in-folder.txt" should not be listed on the webUI
