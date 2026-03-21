#!/bin/bash

distro=$(cat /etc/os-release | grep "^ID=" | cut -d "=" -f2 | sed 's/"//g')

echo
echo
echo
echo "Installing Maven on $distro"

if [ "$distro" == "rhel" ]; then

    sudo yum update -y > /dev/null 2>&1
    sudo yum upgrade -y > /dev/null 2>&1
    sudo yum install wget -y > /dev/null 2>&1
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

#Get the updated link of maven from Apache website. If the link is outdated, then you will see installation error
wget https://dlcdn.apache.org/maven/maven-3/3.9.14/binaries/apache-maven-3.9.14-bin.tar.gz > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo
    echo -e "ERROR: Maven download failed due to outdated link! \nPlease update the correct link in your repo. You can find the link from apache website."
    echo
    exit 1
fi



sudo tar xf apache-maven-3.9.14-bin.tar.gz -C /opt
sudo ln -s /opt/apache-maven-3.9.14 /opt/maven
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
echo "Apache Maven 3.9.14 installed successfully on $distro"
echo
