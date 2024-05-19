# Web Server & Lambda Backend & Cognito Auth & DynamoDB

## Cognito Auth

### Test user signup

**Signup**

User is added to Cognito User Pool.

```
aws cognito-idp sign-up \
 --client-id ${CLIENT_ID} \
 --username ${USER_NAME} \
 --password ${PASSWORD} \
 --user-attributes Name=name,Value=${NAME} Name=email,Value=${EMAIL}
```

**Confirm Signup**

User is confirmed/activated in Cognito User Pool.

```
aws cognito-idp admin-confirm-sign-up  \
  --user-pool-id ${USER_POOL_ID} \
  --username ${USER_NAME}
```

Check that the user has been created and is confirmed.

**Get User**
```
aws cognito-idp admin-get-user \
  --user-pool-id ${USER_POOL_ID} \
  --username ${USER_NAME}
```

https://medium.com/carlos-hernandez/user-control-with-cognito-and-api-gateway-4c3d99b2f414
https://spacelift.io/blog/terraform-api-gateway
https://andrewtarry.com/posts/aws-http-gateway-with-cognito-and-terraform/