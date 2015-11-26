#What is this?
A script to extract and transform PEI Dept of Education testing scores for further processing.

#How do?
***If you need help, reach out to [Matt Duffy](https://github.com/2manyprojects2littletime) and I can try to provide tech support***

##For the curious:

###Requirements:
*a way to to decompress a .zip archive
*a terminal to run the commands
*an internet connection to download the input files
*ruby - the scripting language used to process the files
*pdftotext - a unix utility ... might be available to MSWin through Cygwin?

###To Run:
After making sure you have all the requirements, download the repo as a Zip file (if you're reading this on [github](https://github.com/mcwright/OpenData_School_JSON): the button is above this message, near the right of the screen) and extract the archive to the folder of your choice. (I'm going to assume you've extracted to your user home, `~` on OsX, for future commands)

Open your terminal and navigate into the project folder:
`cd OpenData_School_JSON`

Execute the script:
`ruby fetchPdfs.rb`
You'll see a wall of text start flying by as the input files are downloaded and processed.

When the script finishes executing, you should now have a bunch of `.pdf` files downloaded and `.txt` files created from the process.  The final, machine-readable output will be in a file named `data.json`. If you don't have that file, there was an error: the error message is probably on the last few lines that printed in the terminal above the prompt.  If you can't figure out from the error message what happened, copy the message and open an issue on github with the error in the description for the contributors to diagnose.

##For Contributors
###Requirements:
*git - the source control system
*github account - not strictly required, but makes getting the code and contributing via pull-request(PR) much easier ***I'm also assuming in the commands below that you've set up ssh keys on your github account***
*terminal of choice
*ruby
*pdftotext

### To Run:
After making sure you have all the requirements, fork the repo on github so you have a copy of the project.

Open your terminal and navigate to the parent folder of where you want to keep the repo. e.g. if you have a folder that holds all your projects called MyProjectsFolder then you would type:
`cd MyProjectsFolder`

Clone your copy of the repo to your machine:
`git clone git@github.com:YOUR_USERNAME/OpenData_School_JSON.git`

Execute the script:
`ruby fetchPdfs.rb`

If you make changes and would like to contribute them back, pull the most recent copy of the original repo, create a new branch, commit your changes to that branch, check that your changes still work with the most recent code from the original repo, then push that branch to your fork of the repo and create a PR on the original repo for review and integration.