#include "my_pkg/chatter.h"

#include "std_msgs/String.h"

#include <sstream>

void chatter(ros::Rate& loop_rate, ros::Publisher& pub) {
    int count = 0;

    while (ros::ok()) {
        std_msgs::String msg;

        std::stringstream ss;
        ss << "hello world " << count;
        msg.data = ss.str();

        pub.publish(msg);

        ros::spinOnce();

        loop_rate.sleep();
        ++count;
    }
}
