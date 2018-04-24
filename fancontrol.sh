#!/bin/bash

#Developed by João Barraca Filipe
#Script for controling Asus K55V CPU Fan. 
#Special thanks to Rui Silva.


declare -i TH_0
declare -i TH_1
declare -i TH_2
declare -i TH_3
declare -i TH_4
declare -i TH_5

declare -i PWM_0
declare -i PWM_1
declare -i PWM_2
declare -i PWM_3

declare -i pwm

# Thresholds
TH_0=58000
TH_1=60000
TH_2=65000
TH_3=70000
TH_4=75000
TH_5=80000

# PWM Values
PWM_0=170
PWM_1=195
PWM_2=215
PWM_3=230

pwm=$(cat "/sys/devices/platform/asus-nb-wmi/hwmon/hwmon3/pwm1")
#echo $pwm
while true; do
    	temp="/sys/devices/platform/asus-nb-wmi/hwmon/hwmon3/temp1_input"
	temperature=$(cat $temp)
	echo $temperature
	if [ "$temperature" -le "$TH_0" ]; then
		pwm=$PWM_0
	elif [ "$temperature" -gt "$TH_1" ] && [ "$temperature" -le "$TH_3" ]; then
                if [ "$pwm" -gt "$PWM_1" ]; then
			if [ "$temperature" -le "$TH_2" ]; then
                                pwm=$PWM_1
			fi
                else
                        pwm=$PWM_1
		fi
	elif [ "$temperature" -gt "$TH_3" ] && [ "$temperature" -le "$TH_5" ]; then
                if [ "$pwm" -gt "$PWM_2" ]; then
                        if [ "$temperature" -le "$TH_4" ]; then
                                pwm=$PWM_2
                        fi
                else
                        pwm=$PWM_2
                fi
	elif [ "$temperature" -gt "$TH_5" ]; then
                pwm=$PWM_3
	fi
	echo $pwm
	echo $pwm > /sys/devices/platform/asus-nb-wmi/hwmon/hwmon3/pwm1
	sleep 2
done
