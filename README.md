# Web Server & Lambda Backend & Cognito Auth & DynamoDB

## Cognito Auth

### Test user signup

**Signup**

User is added to Cognito User Pool.

```
aws cognito-idp sign-up \
 --client-id 77c4f07dv39gnrr7rgug5r1v2q \
 --region us-east-1 \
 --username testuser1 \
 --password 12345678 \
 --user-attributes Name=name,Value=Chris Name=email,Value=testuser1@test.com
```

**Confirm Signup**

User is confirmed/activated in Cognito User Pool.

```
aws cognito-idp admin-confirm-sign-up  \
  --region us-east-1 \
  --user-pool-id us-east-1_xT0UwKOG9 \
  --username testuser1
```

Set email as verified

```
aws cognito-idp admin-update-user-attributes \
--user-pool-id us-east-1_xT0UwKOG9 \
--region us-east-1 \
--username testuser1 \
--user-attributes Name=email_verified,Value=true
```

Check that the user has been created and is confirmed.

**Get User**
```
aws cognito-idp admin-get-user \
  --region us-east-1 \
  --user-pool-id us-east-1_xT0UwKOG9 \
  --username chstrong
```

https://medium.com/carlos-hernandez/user-control-with-cognito-and-api-gateway-4c3d99b2f414
https://spacelift.io/blog/terraform-api-gateway
https://andrewtarry.com/posts/aws-http-gateway-with-cognito-and-terraform/
https://urwarrior.medium.com/mapping-of-aws-cognito-options-to-terraform-aabf7ecd651b


https://www.youtube.com/watch?v=vqXLGX0szIQ&t=1426s

