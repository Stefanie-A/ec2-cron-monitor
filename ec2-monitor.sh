#!/bin/bash

INSTANCE_ID=" "

if ! aws sts get-caller-identity > /dev/null 2>&1; then  
    echo "AWS credential not configured. Please configure it using 'aws configure'."
    exit 1
fi

CPU_UTILIZATION=$(aws cloudwatch get-metric-statistics --namespace AWS/EC2 --metric-name CPUUtilization  --period 3600 \
--statistics Maximum --dimensions Name=InstanceId,Value=$INSTANCE_ID \
--start-time $(date -u +"%Y-%m-%dT%H:%M:%SZ" -d '5 minutes ago') \ --end-time $(date -u +"%Y-%m-%dT%H:%M:%SZ") --query 'Datapoints[0].Maximum' --output text)


if [-z "$CPU_UTILIZATION" ] || [ "$CPU_UTILIZATION" == "None" ]; then
    echo "Unable to fetch CPU utilization data."
    exit 1 
fi 

if (( $(echo "$CPU_UTILIZATION >= 80.0" | bc -l) )); then 
    echo "Warning: High CPU utilization on instance $INSTANCE_ID , add autoscaling action"
    aws ec2 stop-instances \
    --instance-ids $INSTANCE_ID
fi

