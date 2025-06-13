Import-Module AWSPowerShell.NetCore


aws configure sso

aws configure sso --profile Altium365


sso page https://11111.awsapps.com/start#/

Environment
environment variables
$Env:AWS_ACCESS_KEY_ID="key"
$Env:AWS_SECRET_ACCESS_KEY="key"
$Env:AWS_SESSION_TOKEN="token"


add a profile 
11111_AdministratorAccess
aws_access_key_id=keyid
aws_secret_access_key=key
aws_session_token=token

$awsProfile= "AdministratorAccess-1111"
$awsProfile= "Profile"

aws ssm start-session --profile $awsProfile `
--region us-east-1 `
--target machineid `
--document-name AWS-StartPortForwardingSession `
--parameters "localPortNumber=50000,portNumber=3389"

aws ssm start-session --profile "AdministratorAccess-1111" --region us-east-1 --target machineid --document-name AWS-StartPortForwardingSession --parameters "localPortNumber=50000,portNumber=3389"


aws ssm start-session --profile "AdministratorAccess-1111" --region us-east-1 --target machineID --document-name AWS-StartPortForwardingSession --parameters "localPortNumber=50000,portNumber=3389"

# aws ssm start-session --target  machineID --document-name AWS-StartPortForwardingSession --parameters "localPortNumber=10101,portNumber=3389"; --profile PROFILE --region us-west-2"

aws ssm start-session --profile "PROFILE" --region us-east-1 --target  




$awsProfile= "GovCloud"

# aws configure --profile $awsProfile    
# AWS Access Key ID [None]: keyID
# AWS Secret Access Key [None]: key
# Default region name [None]: us-gov-east-1
# Default output format [None]: 

# aws s3 ls --profile GovCloud


