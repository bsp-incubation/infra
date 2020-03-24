
jq --arg flb $ex_lb_arn --arg tg1 $UI_tg1 --arg tg2 $UI_tg2 -n '{"LoadBalancerArn":$flb,"Protocol":"HTTP","Port":8080,"DefaultActions":[{"Type":"forward","ForwardConfig":{"TargetGroups":[{"TargetGroupArn":$tg1,"Weight":1},{"TargetGroupArn":$tg2,"Weight":0}],"TargetGroupStickinessConfig":{"Enabled":true,"DurationSeconds":120}}}]}' > ./createFrontListener.json
jq --arg blb $in_lb_arn --arg tg1 $API_tg1 --arg tg2 $API_tg2 -n '{"LoadBalancerArn":$blb,"Protocol":"HTTP","Port":8090,"DefaultActions":[{"Type":"forward","ForwardConfig":{"TargetGroups":[{"TargetGroupArn":$tg1,"Weight":1},{"TargetGroupArn":$tg2,"Weight":0}],"TargetGroupStickinessConfig":{"Enabled":true,"DurationSeconds":120}}}]}' > ./createBackListener.json

aws elbv2 create-listener --cli-input-json ./createFrontListener.json > ./frontListenerOutput.json
aws elbv2 create-listener --cli-input-json ./createBackListener.json > ./backListenerOutput.json

#front listener arn
jq ".Listeners[0].ListenerArn" frontListenerOutput.json -r
#back listener arn
jq ".Listeners[0].ListenerArn" backListenerOutput.json -r
