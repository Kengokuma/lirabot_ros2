from launch import LaunchDescription
from launch_ros.actions import Node


def generate_launch_description():
    return LaunchDescription([
        Node(
            package='lirabot_interface',
            executable='manual_controller_node',
            parameters=['/home/pi/lirabot_ros2/lirabot_interface/config/params.yaml'],
            output='screen'
        ),
        Node(
            package='joy',
            executable='joy_node',
            output='screen'
        ),
    ])