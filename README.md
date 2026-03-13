# install_maven_RHEL_Ubuntu

This script installs maven on your RHEL or Ubuntu machine. You can also install tomcat and Jenkins using this same script after installing maven. You can run the script using this command:

**cd; sudo yum install git -y > /dev/null 2>&1; git clone https://github.com/nagaraj602/install_maven_RHEL_Ubuntu.git &> /dev/null; cd install_maven_RHEL_Ubuntu; bash maven.sh**

—---------------------------------------------------------------------------------------------------------------------------- 
# If you get error saying: 
"ERROR: Maven download failed due to outdated link!
Please update the correct link in your repo. You can find the link from apache website."

You can visit: https://maven.apache.org/download.cgi \n
Find the latest version of maven. Then update the version number in "maven.sh" script.
