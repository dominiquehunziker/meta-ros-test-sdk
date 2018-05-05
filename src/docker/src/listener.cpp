#include <fstream>

#include "ros/ros.h"

#include "std_msgs/String.h"

void chatterCallback(const std_msgs::String::ConstPtr& msg) {
    ROS_INFO("I heard: [%s]", msg->data.c_str());

    std::ofstream file;
    file.open ("/home/root/status.txt");
    file << "SUCCESS\n";
    file.close();

    ros::shutdown();
}

int main(int argc, char **argv) {
    ros::init(argc, argv, "listener");

    ros::NodeHandle n;

    ros::Subscriber sub = n.subscribe("chatter", 1000, chatterCallback);
    ros::spin();

    return 0;
}
