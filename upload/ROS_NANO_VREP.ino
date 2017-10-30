/*
 * rosserial PubSub Example
 * Prints "hello world!" and toggles led
 */

 /*
  * roscore
  * rosrun rosserial_python serial_node.py /dev/ttyUSB0
  * run vrep ARM_IK_ROS
  */

#include <ros.h>
#include <std_msgs/String.h>
#include <std_msgs/Empty.h>
#include <std_msgs/Float32MultiArray.h>

ros::NodeHandle  nh;

std_msgs::String str_msg;
ros::Publisher Status("Status", &str_msg);

char hello[17] = "Command Recevied!";

void messageCb( const std_msgs::Empty& toggle_msg){
  digitalWrite(13, HIGH-digitalRead(13));   // blink the led
  
  str_msg.data = hello;
  Status.publish( &str_msg );
}

ros::Subscriber<std_msgs::Empty> sub("toggle_led", messageCb );
ros::Subscriber<std_msgs::Float32MultiArray> sub2("all_joint_position", messageCb);

void setup()
{
  pinMode(13, OUTPUT);
  nh.initNode();
  nh.advertise(Status);
  nh.subscribe(sub);
  nh.subscribe(sub2);
}

void loop()
{  
  nh.spinOnce();
  delay(10);
}




