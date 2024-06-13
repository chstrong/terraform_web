# Web Server & Lambda Backend & Cognito Auth & DynamoDB

## Cognito Auth

### Test user signup

**Set AWS Profile**

Set the right AWS profile.

```
export AWS_PROFILE=tailorapp
```

**Signup**

Create Secret Hash from username and client id

```
echo -n "testuser131gpotcta9s2qats3hnogtpdkc" | openssl dgst -sha256 -hmac 64cmuamjhm0duqs4rm6s6ngrfda5ut3tt8fdcb8iqq5vlv51c3e -binary | openssl enc -base64
```

User is added to Cognito User Pool.

```
aws cognito-idp sign-up \
 --client-id 31gpotcta9s2qats3hnogtpdkc \
 --secret-hash bF9lqJdXUR26LZdjchYHuIb3DihQ/VFZauCrSoTSre0= \
 --region us-east-1 \
 --username testuser1 \
 --password 12345678 \
 --user-attributes Name=name,Value=Chris Name=email,Value=testuser1@test.com
```

**Confirm Signup**

User is confirmed/activated in Cognito User Pool.

```
aws cognito-idp admin-confirm-sign-up \
  --region us-east-1 \
  --user-pool-id us-east-1_2z8v5q6gc \
  --username testuser1
```

Set email as verified

```
aws cognito-idp admin-update-user-attributes \
--user-pool-id us-east-1_2z8v5q6gc \
--region us-east-1 \
--username testuser1 \
--user-attributes Name=email_verified,Value=true
```

Check that the user has been created and is confirmed.

**Get User**

Display user details.

```
aws cognito-idp admin-get-user \
  --region us-east-1 \
  --user-pool-id us-east-1_2z8v5q6gc \
  --username testuser1
```

**Get Token**

Get Token

```
aws cognito-idp initiate-auth \
 --region us-east-1 \
 --client-id 31gpotcta9s2qats3hnogtpdkc \
 --auth-flow USER_PASSWORD_AUTH \
 --auth-parameters USERNAME=testuser1,PASSWORD=12345678,SECRET_HASH=bF9lqJdXUR26LZdjchYHuIb3DihQ/VFZauCrSoTSre0= \
 --query 'AuthenticationResult.IdToken' \
 --output text
```

https://medium.com/carlos-hernandez/user-control-with-cognito-and-api-gateway-4c3d99b2f414
https://spacelift.io/blog/terraform-api-gateway
https://andrewtarry.com/posts/aws-http-gateway-with-cognito-and-terraform/
https://urwarrior.medium.com/mapping-of-aws-cognito-options-to-terraform-aabf7ecd651b


https://www.youtube.com/watch?v=vqXLGX0szIQ&t=1426s

## Test Lambda HTTP Functions

```
curl \
--header "Content-Type: application/json" \
--request POST \
--data '{"id":"ri94303r", "name": "Name1", "content": "Content"}' \

```


aws cognito-idp admin-set-user-password \
     --user-pool-id us-east-1_2z8v5q6gc \
     --username "chstrong" \
     --password "Test123456" \
     --region us-east-1 \
     --permanent