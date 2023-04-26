# How to use the public sandbox with your own agent

![public_sandbox.png](doc%2Fpublic_sandbox.png)

This documentation will show you how to create a DID and connect your issuing agent to the endorser of the FOITT (Federal Office of Information Technology, Systems and Telecommunication)

> **New to SSI?**   
> There are several courses out there, which give you a good overview about the technology
> - GitHub [Getting started with Aries](https://github.com/hyperledger/aries-cloudagent-python/blob/main/docs/GettingStartedAriesDev/README.md)
> - edX [Introduction to Hyperledger SSI Blockchain solutions](https://www.edx.org/course/identity-in-hyperledger-aries-indy-and-ursa)
> - edX [Becoming a Hyperledger Aries Developer](https://www.edx.org/course/becoming-a-hyperledger-aries-developer)
> - Hyperledger [Aries](https://wiki.hyperledger.org/display/ARIES/Hyperledger+Aries)

<!-- TOC -->
* [How to use the public sandbox with your own agent](#how-to-use-the-public-sandbox-with-your-own-agent)
  * [About this setup](#about-this-setup)
  * [Before applying](#before-applying)
    * [Generate DID without providing a seed](#generate-did-without-providing-a-seed)
      * [1. Start issuer](#1-start-issuer)
      * [2. Generate did](#2-generate-did)
    * [Alternative variant: Generate DID by providing a seed](#alternative-variant-generate-did-by-providing-a-seed)
      * [1. Generate seed](#1-generate-seed)
      * [2. Generate DID (by providing seed)](#2-generate-did-by-providing-seed)
      * [3. List local DID](#3-list-local-did)
  * [Applying for the Public Sandbox Trust Infrastructure](#applying-for-the-public-sandbox-trust-infrastructure)
  * [After your applied](#after-your-applied)
    * [1. Check your mail inbox](#1-check-your-mail-inbox)
    * [2. Accept the invitation](#2-accept-the-invitation)
    * [3. Specify the endorsing connection](#3-specify-the-endorsing-connection)
  * [Issue a credential](#issue-a-credential)
    * [1. Create a schema](#1-create-a-schema)
    * [2. Create a credential definition](#2-create-a-credential-definition)
    * [3. Create an invitation](#3-create-an-invitation)
    * [6. Issue and send a credential](#6-issue-and-send-a-credential)
    * [What next?](#what-next)
<!-- TOC -->

## About this setup

![security_consideration.svg](doc%2Fsecurity_consideration.svg)

![diagramm.png](doc%2Fdiagramm.png)

By using the [docker-compose.yml](docker-compose.yml) file in this repository you'll get a local setup like shown above. Its main purpose is to give an impression of what components you need to run in your stable environment. 

**Credentials**

The credentials used in this example are for demonstration purpose only. For your environment, stronger credentials are recommended.

**Requirements for the local setup**
- [Docker](https://docs.docker.com/engine/install/ubuntu/)
- [Docker compose plugin](https://www.postman.com/)
- [Postman](https://www.postman.com/) or another REST-Client

**Additional requirement for the stable environment**
- Public reachable agent 
- Independent PostgreSQL database (to assure that the wallet persists even when the agent should be destroyed)

We strongly advice you to build and deploy your own images to be able to implement the necessary level of security that is needed for your use case.

## Before [applying](https://github.com/e-id-admin/public-sandbox-trustinfrastructure#how-to-apply-to-the-sandbox)

### Generate DID without providing a seed
This variant explains how to generate a decentralized identifier (DID) in an stable environment - here you can be sure that your database is stable. This is important because you won't be able to see the seed after you created the DID. This means: When you lose your wallet/database you won't be able to use the DID anymore, unless you have a backup at hand.

#### 1. Start issuer
Because you don't set the seed, the environment variables don't need to be touched.

<details>
<summary>Default configuration</summary>

```
  environment:
      #- ACAPY_WALLET_SEED=<your seed>
      #- ACAPY_NO_LEDGER=True
      - ACAPY_GENESIS_URL=https://raw.githubusercontent.com/e-id-admin/public-sandbox-trustinfrastructure/main/pool_genesis
```

</details>


Start the agent
```bash
docker compose up
```
#### 2. Generate did
Once the agent is started, send the following request to the wallet endpoint

POST /wallet/did.
```json
{
  "method": "sov",
  "options": {
    "key_type": "ed25519"
  }
}
```

The response should look like this
```json
{
    "result": {
        "did": "UFSGJYAEMUzUikXR3JscLG",
        "verkey": "FrPghTFyDpgBSv77GJM9VFu5AGknFVzJAvLDo7A4MfNn",
        "posture": "wallet_only",
        "key_type": "ed25519",
        "method": "sov"
    }
}
```

<details>
<summary>
Alternative variant: Generate DID by providing a seed
</summary>

### Alternative variant: Generate DID by providing a seed
This variant explains how to generate a decentralized identifier (DID) by specifying the seed. This is especially useful, when you generate the DID in a non-stable environment, like on your local machine.
#### 1. Generate seed
To generate a DID, a seed (string consisting of  32 charachters) is needed which serves as cryptographical proof that you're in possession of the DID. If you don't have a seed available, you can generate one on your own by executing the following script
```bash
bash generate-seed.sh
```
As result, you get the output with your seed
 ```
Your seed is RnQs0nrQPizSROxSjDzxT+gODdK7rNm+
```

#### 2. Generate DID (by providing seed)
After you put the seed into the docker-compose file, the agent can now be started without specifying the ledger. This can be achieved by the following environment variables in the docker-compose.yml

```
  environment:
      #- ACAPY_WALLET_SEED=<your seed>
      #- ACAPY_NO_LEDGER=True
      - ACAPY_GENESIS_URL=https://raw.githubusercontent.com/e-id-admin/public-sandbox-trustinfrastructure/main/pool_genesis
```

```bash
docker compose up
```
If the setup is running, you'll see an output similar to this one
```
ssi_issuing-cookbook-issuer-1  | 
ssi_issuing-cookbook-issuer-1  | ::::::::::::::::::::::::::::::::::::::::::::::
ssi_issuing-cookbook-issuer-1  | :: Aries Cloud Agent                        ::
ssi_issuing-cookbook-issuer-1  | ::                                          ::
ssi_issuing-cookbook-issuer-1  | ::                                          ::
ssi_issuing-cookbook-issuer-1  | :: Inbound Transports:                      ::
ssi_issuing-cookbook-issuer-1  | ::                                          ::
ssi_issuing-cookbook-issuer-1  | ::   - http://0.0.0.0:8002                  ::
ssi_issuing-cookbook-issuer-1  | ::                                          ::
ssi_issuing-cookbook-issuer-1  | :: Outbound Transports:                     ::
ssi_issuing-cookbook-issuer-1  | ::                                          ::
ssi_issuing-cookbook-issuer-1  | ::   - http                                 ::
ssi_issuing-cookbook-issuer-1  | ::   - https                                ::
ssi_issuing-cookbook-issuer-1  | ::                                          ::
ssi_issuing-cookbook-issuer-1  | :: Administration API:                      ::
ssi_issuing-cookbook-issuer-1  | ::                                          ::
ssi_issuing-cookbook-issuer-1  | ::   - http://0.0.0.0:8000                  ::
ssi_issuing-cookbook-issuer-1  | ::                                          ::
ssi_issuing-cookbook-issuer-1  | ::                               ver: 0.8.1 ::
ssi_issuing-cookbook-issuer-1  | ::::::::::::::::::::::::::::::::::::::::::::::
ssi_issuing-cookbook-issuer-1  | 
ssi_issuing-cookbook-issuer-1  | 
ssi_issuing-cookbook-issuer-1  | Listening...
ssi_issuing-cookbook-issuer-1  | 
```

<details>
<summary>Import Swagger Endpoints in Postman - Set Api Key</summary>

If you're using Postman you can import the different endpoints of the agent by using the published swagger-doc

<img src="doc/postman_swagger-import.png" width="870">

<img src="doc/postman_env-variable.png" width="870">

<img src="doc/postman_api-key.png" width="870">
</details>

#### 3. List local DID

> To access the endpoint the X-API-KEY header has to be set

To see the did, which was generated based on the seed, call the endpoint
GET http://0.0.0.0:8000/wallet/did. The output should be similar to this
```json
{
    "results": [
        {
            "did": "DnqWntWkRLBJrxET1JFypP",
            "verkey": "7yKuvFRr1CJU2qFY3iSiktDTL6Fw3fe8xyXjPR3jSXNk",
            "posture": "posted",
            "key_type": "ed25519",
            "method": "sov"
        }
    ]
}
```


</details>


## Applying for the Public Sandbox Trust Infrastructure
Now that you've created your DID you can apply to access the Public Sandbox Trust Infrastructure (ledger) by following the guide [How to apply to the public sandbox](https://github.com/e-id-admin/public-sandbox-trustinfrastructure#how-to-apply-to-the-sandbox). In the process you need to fill in the previously generated information in the template.

<details>
<summary>Application form example</summary>

![technical_data_issuer-owner.png](doc%2Ftechnical_data_issuer-owner.png)

</details>

## After your [applied](https://github.com/e-id-admin/public-sandbox-trustinfrastructure#how-to-apply-to-the-sandbox)
### 1. Check your mail inbox
After you applied successfully you should have received an e-mail with an invitation similar to this one

```json
{
  "@type": "did:sov:{some did};spec/connections/1.0/invitation",
  "@id": "{some did}",
  "label": "Connector",
  "serviceEndpoint": "https://endorser.sandbox.ssi.ch",
  "recipientKeys": ["2yvxwCN7x3fDU6bPJfc8L9izKPLy8QwxRStSpZiVA6YC"]
}
```

### 2. Accept the invitation
> The following steps should be performed in a stable-environment

Accept the invitation by sending the mail content to the invitation endpoint

POST /connections/receive-invitation?alias=foittendorser&auto_accept=true

*Request*
```json
{
  "@type": "did:sov:{some did};spec/connections/1.0/invitation",
  "@id": "{some did}",
  "label": "Connector",
  "serviceEndpoint": "https://endorser.sandbox.ssi.ch",
  "recipientKeys": ["2yvxwCN7x3fDU6bPJfc8L9izKPLy8QwxRStSpZiVA6YC"]
}
```

*Response*
```json
{
  "results": [
    {
      "connection_protocol": "connections/1.0",
      "state": "active",
      "invitation_mode": "once",
      "their_role": "xxx",
      "invitation_key": "xxx",
      "their_label": "xxxx",
      "created_at": "xxx",
      "accept": "auto",
      "routing_state": "none",
      "my_did": "xxx",
      "updated_at": "xxxx",
      "rfc23_state": "xxx",
      "their_did": "xxx",
      "connection_id": "5c910571-5d5f-451d-8e6b-40f8dee3dd20"
    }
  ]
}
```

 ### 3. Specify the endorsing connection

To make the issuer-agent aware, that it should send the transaction to endorser, two request are needed.

**Set endorser role**
> **:conn_id** needs to be replaced with the 'connection_id' of the previous response

POST /transactions/:conn_id/set-endorser-role?transaction_my_job=TRANSACTION_AUTHOR

*Response*
```json
{
  "transaction_my_job": "TRANSACTION_AUTHOR"
}
```

**Set endorser info**
> **:conn_id** needs to be replaced with the 'connection_id' of the previous response

POST /transactions/:conn_id/set-endorser-info?endorser_did=8WzWX4G3Rti6tVSX3Atcvo&endorser_name=foittendorser

*Response*
```json
{
    "endorser_did": "8WzWX4G3Rti6tVSX3Atcvo",
    "endorser_name": "foittendorser"
}
```

## Issue a credential

> **Before you continue**  
> Keep in mind that the diagrams and requests in this section are strong-abstracted and only serve to give an idea of the flow.
> For more detailed information visit the [aries-rfcs](https://github.com/hyperledger/aries-rfcs/tree/main/concepts) which explains the detailed process of the individual steps

Now that your issuer is connected to the endorser of the FOITT, you're able to move on to issue credentials. For the sake of simplicity, this example will lack the possibility to revoke issued credentials for now. Let's imagine the following credential "MySpecialId" with some attributes:

| Key       | Value         |
|-----------|---------------|
| firstName | "John"        |
| lastName  | "Doe"         |
| birthdate | "01.01.2000"  |


**How can you achieve this?**

![diagramm_connection-issuing.png](doc%2Fdiagramm_connection-issuing.png)

1. [Create a schema whith the attributes you want to have in the credentials](#1-create-a-schema)
2. [Create a credential definition (a unique instance of that schema which is used for issuing credentials)](#2-create-a-credential-definition)
3. [Create an invitation for one or more holders](#3-create-an-invitation)
4. Transmit the invitation to the holder. This could be achieved by scanning a qr-code, calling the link etc. 
5. A connection can be accepted in an automated fashion, which means that some additional request are made in the background
6. [Issue a credential based on the credential definition.](#6-issue-and-send-a-credential)
7. The holder has received a "MySpecialId" and can use it in a proof request

**Used issuing approach**

The flow to issue a credential varies depending on your use-case. In the following example only requests from the highlighted section are used.

![aries-issuing-flow.png](doc%2Faries-issuing-flow.png)

Source [0036-issue-credential](https://github.com/hyperledger/aries-rfcs/tree/bb42a6c35e0d5543718fb36dd099551ab192f7b0/features/0036-issue-credential#messages)

### 1. Create a schema
Insert the attributes required for your credential and send the request. By doing so, a transaction will be sent to the endorser which checks if you're allowed to send transaction to the ledger

> **Change schema name**  
> In this example the name of the schema with this request will be "MySpecialId". Because we prohibit the reuse of an already existing schema name, please replace the value of the attribute "schema_name" with another unique value 

POST /schemas
```json
{
  "attributes": [
      "firstName",
      "lastName",
      "birthdate"
  ],
  "schema_name": "MySpecialId",
  "schema_version": "1.0"
}
```
*Response*
```json
{
    "sent": {
        "schema_id": "FGn2c4rWJbXZ8AbCpEyr2u:2:MySpecialId:1.0",
        "schema": {
            "signed_txn": "{\"endorser\": \"Bo4wiuWLuHQoHcqwJrgKZt\", \"identifier\": \"FGn2c4rWJbXZ8AbCpEyr2u\", \"operation\": {\"data\": {\"attr_names\": [\"firstName\", \"birthdate\", \"lastName\"], \"name\": \"MySpecialId\", \"version\": \"1.0\"}, \"type\": \"101\"}, \"protocolVersion\": 2, \"reqId\": 1681983654399428732, \"signature\": \"4uSJomLARrVcejVzNJMv5ngut37QJpBZ2VMVKv5Gf4NaUasfd3zvAV4Fb1sNC9TBWf65NAy3Qr8kvfN54SFi1veX\"}"
        }
    },
    "txn": {
        "timing": {
            "expires_time": null
        },
        "transaction_id": "3dcd92c3-e803-4202-98bd-86f3645805ea",
        "created_at": "2023-04-20T09:40:54.406021Z",
        "_type": "http://didcomm.org/sign-attachment/%VER/signature-request",
        "meta_data": {
            "context": {
                "schema_id": "FGn2c4rWJbXZ8AbCpEyr2u:2:MySpecialId:1.0",
                "schema_name": "MySpecialId",
                "schema_version": "1.0",
                "attributes": [
                    "firstName",
                    "lastName",
                    "birthdate"
                ]
            },
            "processing": {}
        },
        "state": "request_sent",
......
```

### 2. Create a credential definition
Copy the value of the attribute "schema_id" and use it in the new request 
```json
{
  "schema_id": "FGn2c4rWJbXZ8AbCpEyr2u:2:MySpecialId:1.0",
  "support_revocation": false,
  "tag": "1.0"
}
```
*Response*
```json
{
    "sent": {
        "credential_definition_id": "Bo4wiuWLuHQoHcqwJrgKZt:3:CL:20:1.0"
    },
    "credential_definition_id": "Bo4wiuWLuHQoHcqwJrgKZt:3:CL:20:1.0"
}
```
### 3. Create an invitation
> **Who is going to accept the invitation?**   
> If you're stumbling at this point, asking yourself who this "different agent" could be, then it might be helpful to look the courses mentioned [at the beginning](#how-to-use-the-public-sandbox-with-your-own-agent) or setup locally [one of the demo use-cases (with alice, bob, faber college)](https://github.com/hyperledger/aries-cloudagent-python/blob/main/docs/GettingStartedAriesDev/DecentralizedIdentityDemos.md) provided by hyperledger. These show how different agents interact with each-other by using a connection
 
To send a credential to a holder, a channel / connection needs to be setup beween the agents upfront. This process is initiated by creating an invitation.
At this point you need a different/receiving agent which is going to accept the invitation.

POST /connections/create-invitation?auto_accept=true&alias=myConnection

*Response*
```json
{
    "connection_id": "afb49d06-4bff-453b-a64f-48cb51b9fb04",
    "invitation": {
        "@type": "did:sov:xxxxx;spec/connections/1.0/invitation",
        "@id": "7c2b529a-5302-4d5e-9c2d-e8f34d1782e0",
        "label": "Aries Cloud Agent",
        "recipientKeys": [
            "xxxxx"
        ],
        "serviceEndpoint": "http://xxxx.azure.com:8001"
    },
    "invitation_url": "http://xxxx.azure.com:8001?c_i=hereIsSomeBase64String",
    "alias": "myConnection"
}
```
### 6. Issue and send a credential

POST /issue-credential-2.0/send

*Body*
```json
{
  "connection_id": "afb49d06-4bff-453b-a64f-48cb51b9fb04",
  "filter": {
    "indy": {
      "cred_def_id": "Bo4wiuWLuHQoHcqwJrgKZt:3:CL:20:1.0",
      "issuer_did": "Bo4wiuWLuHQoHcqwJrgKZt",
      "schema_id": "Bo4wiuWLuHQoHcqwJrgKZt:2:MySpecialId:1.0",
      "schema_issuer_did": "Bo4wiuWLuHQoHcqwJrgKZt",
      "schema_name": "MySpecialId",
      "schema_version": "1.0"
    }
  },
  "auto_remove": true,
  "comment": "Test credential for tutorial",
  "credential_preview": {
    "attributes": [
      {
        "name": "firstName",
        "value": "Jon",
        "mime-type": "text/plain"
      },
      {
        "name": "lastName",
        "value": "Doe",
        "mime-type": "text/plain"
      },
      {
        "name": "birthdate",
        "value": "01.01.2000",
        "mime-type": "text/plain"
      }
    ],
    "@type": "issue-credential/2.0/credential-preview"
  },
  "trace": true
}
```

### What next?
Congrats, you arrived at the end :-) ! Not only have you established an endorsing connection with the FOITT endorser, but as well set up your own agent which whom you can issue credentials from now on. For further information on the SSI topic, feel free to have look at the courses mentioned [at the beginning](#how-to-use-the-public-sandbox-with-your-own-agent)

**Troubles?**

If you consulted the documentation but still need a helping hand you're welcome to contact us by mail [ssi-sandbox@bit.admin.ch](mailto:ssi-sandbox@bit.admin.ch) 
