#include "my_pkg/chatter.h"

#include "std_msgs/String.h"

int main(int argc, char **argv) {
    ros::init(argc, argv, "talker");

    ros::NodeHandle n;

    ros::Publisher chatter_pub = n.advertise<std_msgs::String>("chatter", 1000);

    ros::Rate loop_rate(10);
    
    chatter(loop_rate, chatter_pub);
}
