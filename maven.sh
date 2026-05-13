#!/bin/bash

distro=$(cat /etc/os-release | grep "^ID=" | cut -d "=" -f2 | sed 's/"//g')

MAVEN_VERSION="3.9.15"

echo
echo
echo
echo "Installing Maven on $distro"

if [ "$distro" == "rhel" ] || [ "$distro" == "amzn" ]; then

    sudo yum update -y > /dev/null 2>&1
    sudo yum upgrade -y > /dev/null 2>&1
    sudo yum install wget tar -y > /dev/null 2>&1
    sudo dnf install java-25-openjdk-devel -y > /dev/null 2>&1
    sudo yum install java-25-amazon-corretto -y > /dev/null 2>&1

elif [ "$distro" == "ubuntu" ]; then

    sudo apt-get update -y > /dev/null 2>&1
    sudo apt-get upgrade -y > /dev/null 2>&1
    sudo apt-get install wget tar openjdk-25-jdk -y > /dev/null 2>&1

else
    echo "Unsupported Distribution - Only RHEL, Ubuntu and Amazon Linux are supported by this Script!!!!"
    exit 1
fi

JAVA_HOME_PATH=$(dirname $(dirname $(readlink -f $(which javac))))

sudo rm -rf /opt/apache-maven-* /opt/maven /usr/local/bin/mvn > /dev/null 2>&1

cd /tmp

wget https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo
    echo -e "ERROR: Maven download failed due to outdated link! \nPlease update the correct link in your repo. You can find the link from apache website."
    echo
    exit 1
fi

sudo tar xf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt > /dev/null 2>&1

sudo ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven > /dev/null 2>&1
sudo ln -s /opt/maven/bin/mvn /usr/local/bin/mvn > /dev/null 2>&1

sudo tee /etc/profile.d/maven.sh > /dev/null <<EOF
export JAVA_HOME=$JAVA_HOME_PATH
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=\${M2_HOME}/bin:\${PATH}
EOF

sudo chmod +x /etc/profile.d/maven.sh > /dev/null 2>&1

source /etc/profile.d/maven.sh

echo
echo "Apache Maven ${MAVEN_VERSION} installed successfully on $distro"
echo
