# wordpress-task

#  steps 

Clone this repository( git must be installed in your system ) 
git clone https://github.com/srbharath/wordpress-task.git

#       move to the directory
cd wordpress-task

#  Provide execution permission to this file
chmod +x create-wordpress-site.sh

#  Run the file
sh create-wordpress-site.sh example.com

# what does this script do
1) it will check whether the docker and docker-compose is installed or not, if it is not installed it will install both
2) it will create a directory called example.com and it will create docker-compose file inside this directory
3) This docker-compose file will run and our wordpress site will be running


#  Open Browser and search localhost/example.com  { if you using aws ec2 paste server ip insted of localhost }




#  To disable the site and delete the containers
sh disable-wordpress-site.sh example.com

#  site and containers will be deleted  
