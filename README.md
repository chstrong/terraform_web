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

**Test Login**

```
curl -H "Authorization: ${TOKEN}" https://elya19mfb3.execute-api.us-east-1.amazonaws.com/auth
```

curl -H "Authorization: eyJraWQiOiJZODBSUWZVQnRrcmtLV1AzbVBNYjd6dEVJVUJJb24xNTlhQk5wK295THBVPSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiI0NGI4YzQxOC02MDcxLTcwMzgtZjhiOC1kNDhlNjIzYzY2NzkiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiaXNzIjoiaHR0cHM6XC9cL2NvZ25pdG8taWRwLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tXC91cy1lYXN0LTFfMno4djVxNmdjIiwiY29nbml0bzp1c2VybmFtZSI6InRlc3R1c2VyMSIsIm9yaWdpbl9qdGkiOiIxZjIyOGU3Yy1mMjcxLTQ0ODUtOTRlYy1jNzU2ODdkNzE3ZWUiLCJhdWQiOiIzMWdwb3RjdGE5czJxYXRzM2hub2d0cGRrYyIsImV2ZW50X2lkIjoiNzI0YTc3ZDktNDAwZS00YzM0LWFmYzgtM2EyZjU0Njg4YjFiIiwidG9rZW5fdXNlIjoiaWQiLCJhdXRoX3RpbWUiOjE3MTgzMjA0NjAsIm5hbWUiOiJDaHJpcyIsImV4cCI6MTcxODMyNDA2MCwiaWF0IjoxNzE4MzIwNDYwLCJqdGkiOiI4ODQwY2RiZi1jZGU0LTRiYzItYTVmMi1mOGU0NmI0MGQ2NWIiLCJlbWFpbCI6InRlc3R1c2VyMUB0ZXN0LmNvbSJ9.G6iu1weOrdt3SwflIpcBtjajpb8-L-UAmTTGXFtDqxpBPpIq4OI1dJE2my6Er2lsX9qxSy9npikNPrn1wx40fWNa8_d3dTUvPZAZ1PC6eBBhi1oEFH_giR7L66jYeanAIyB_dpHRYUO3YgdW7V0FSjdslEmSwIQzLPkbCGLa6rHxO-ujN6HCchmAuMAehd2_gvfC-69UIrJyJkldT58JHfYgVZGT0aYAhqhg2fzJODoDwuRIdZjQrPjZV072IUALf1t4s_uanAFYsaH8XjTjhOI4UJA-7WJoT8qoWOTi8BrwTYytGUWJ6940hItDwVzVatElcEqPq4L7OyQe_BJ8UA" https://elya19mfb3.execute-api.us-east-1.amazonaws.com/auth

## Test Lambda HTTP Functions

```
curl \
--header "Content-Type: application/json" \
--request POST \
--data '{"id":"ri94303r", "name": "Name1", "content": "Content"}' \
https://ulx2fav0k5.execute-api.us-east-1.amazonaws.com/todo/add
```

## Tutorials

https://medium.com/carlos-hernandez/user-control-with-cognito-and-api-gateway-4c3d99b2f414
https://spacelift.io/blog/terraform-api-gateway
https://andrewtarry.com/posts/aws-http-gateway-with-cognito-and-terraform/
https://urwarrior.medium.com/mapping-of-aws-cognito-options-to-terraform-aabf7ecd651b
https://www.youtube.com/watch?v=vqXLGX0szIQ&t=1426s
https://mahira-technology.medium.com/deploying-aws-amplify-using-terraform-62be45cd25f2 (Amplify)

