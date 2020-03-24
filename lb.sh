
aws elbv2 create-listener --load-balancer-arn $ex_lb_arn \
--protocol HTTP \
--port 8080 \
--default-actions "[{'Type': 'forward', 'ForwardConfig': {'TargetGroups': [{'TargetGroupArn': $UI_tg1, 'Weight': 1}, {'TargetGroupArn': $UI_tg2, 'Weight': 0}]}}]"

aws elbv2 create-listener --load-balancer-arn $in_lb_arn \
--protocol HTTP \
--port 8090 \
--default-actions "[{'Type': 'forward', 'ForwardConfig': {'TargetGroups': [{'TargetGroupArn': $API_tg1, 'Weight': 1}, {'TargetGroupArn': $API_tg2, 'Weight': 0}]}}]"