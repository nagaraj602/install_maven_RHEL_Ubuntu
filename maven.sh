#!/bin/bash

distro=$(cat /etc/os-release | grep "^ID=" | cut -d "=" -f2 | sed 's/"//g')

echo "Installing Maven on $distro"

if [ "$distro" == "rhel" ]; then

    sudo yum update -y > /dev/null 2>&1
    sudo dnf install java-25-openjdk-devel -y > /dev/null 2>&1

elif [ "$distro" == "ubuntu" ]; then

    sudo apt-get update -y > /dev/null 2>&1
    sudo apt-get upgrade -y > /dev/null 2>&1
    sudo apt-get install openjdk-25-jdk -y > /dev/null 2>&1

else
    echo "Unsupported Distribution - Only RHEL and Ubuntu are supported by this Script!!!!"
    exit 1
fi

# Dynamically detect JAVA_HOME
JAVA_HOME_PATH=$(dirname $(dirname $(readlink -f $(which javac))))


# Remove old Maven if exists
sudo rm -rf /opt/apache-maven-* /opt/maven /usr/local/bin/mvn > /dev/null 2>&1


cd /tmp

wget https://dlcdn.apache.org/maven/maven-3/3.9.12/binaries/apache-maven-3.9.12-bin.tar.gz > /dev/null 2>&1

sudo tar xf apache-maven-3.9.12-bin.tar.gz -C /opt
sudo ln -s /opt/apache-maven-3.9.12 /opt/maven
sudo ln -s /opt/maven/bin/mvn /usr/local/bin/mvn



sudo tee /etc/profile.d/maven.sh > /dev/null <<EOF
export JAVA_HOME=$JAVA_HOME_PATH
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=\${M2_HOME}/bin:\${PATH}
EOF

sudo chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh


echo
echo "Apache Maven 3.9.12 installed successfully on $distro"
echo










echo
echo "Do you want to exit from this script? Or perform another operation?"
echo "1) Exit"
echo "2) Install Tomcat"
echo "3) Install Jenkins"
echo

read -p "Enter your choice [1-3]: " choice

case $choice in
    1)
        echo "Exiting script..."
        exit 0
        ;;

    2)
        echo "Installing Tomcat..."
        cd
        sudo yum install git -y > /dev/null 2>&1
        rm -rf install_tomcat_RHEL_Ubuntu
        git clone https://github.com/NagarajKamath/install_tomcat_RHEL_Ubuntu.git > /dev/null 2>&1
        cd install_tomcat_RHEL_Ubuntu || exit
        bash tomcat.sh
        ;;

    3)
        echo "Installing Jenkins..."
        cd
        sudo yum install git -y > /dev/null 2>&1
        rm -rf install_jenkins_RHEL_Ubuntu
        git clone https://github.com/nagaraj602/install_jenkins_RHEL_Ubuntu.git > /dev/null 2>&1
        cd install_jenkins_RHEL_Ubuntu || exit
        bash jenkins.sh
        ;;

    *)
        echo "Invalid option. Exiting."
        exit 1
        ;;
esac
