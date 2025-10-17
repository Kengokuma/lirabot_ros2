#!/bin/bash

# micro-ROS通信セットアップスクリプト（screen使用）

# 設定
SESSION_NAME="micro_ros_setup"
DEV_PORT="/dev/ttyACM0"
BAUD_RATE="115200"

# 既存のscreenセッションがあれば終了
screen -ls | grep -q "$SESSION_NAME"
if [ $? -eq 0 ]; then
    echo "既存のscreenセッション '$SESSION_NAME' を終了します。"
    screen -X -S "$SESSION_NAME" quit
fi

echo "micro-ROSセットアップを開始します..."
echo "-------------------------------------"
# ROS 2 環境のセットアップ
source install/setup.bash

echo "====================================="
echo "🔴 1回目 sudo chmod 実行 🔴"
echo "パスワードを入力してください。"
echo "====================================="
# メインの対話セッションでsudoを実行
sudo chmod 777 $DEV_PORT 
echo "権限設定完了"

# 1. screenセッションを作成し、ウィンドウ0（agent用）でシェルを起動
screen -S "$SESSION_NAME" -t "agent_run" -d -m

echo ""
echo "====================================="
echo "🔴 手動操作が必要です 🔴"
echo "ロボット後部の基板上の赤色のスイッチを後ろに倒してオンにしてください。"
echo "====================================="
read -p "👆 スイッチ操作が完了したら Enter キーを押してください..."

# 2. agentの実行 (ウィンドウ0: agent_run)
echo "ウィンドウ0 (agent) で 'ros2 run micro_ros_agent serial...' を実行します..."
screen -S "$SESSION_NAME" -p 0 -X stuff "ros2 run micro_ros_agent micro_ros_agent serial --dev $DEV_PORT --baud $BAUD_RATE^M"

# 3. 手動操作後のステップ
echo "====================================="
echo "🔴 手動操作が必要です 🔴"
echo "ロボット後部の基板上を **オンからオフ、そして再度オン** にして、ボードをリセットしてください。"
echo "====================================="
read -p "👆 スイッチ操作（オンオフ）が完了したら Enter キーを押してください..."

echo "デバイスが再接続されるまで3秒間待機します..."
sleep 3 
# --------------------------------------------------

echo "====================================="
echo "🔴 2回目 sudo chmod 実行 🔴"
echo "パスワードを入力してください。"
echo "====================================="
sudo chmod 777 $DEV_PORT 
echo "権限設定完了"


echo ""
echo "✅ 全てのコマンドを実行しました。"
echo "-------------------------------------"

# 5. screenセッションにアタッチ
screen -r "$SESSION_NAME"