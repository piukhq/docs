---
title: Appendix
output: html_document
---
## Statuses for Loyalty Cards

Status gets returned through the API in the below structure:

```json
"status": {
    "state": "authorised",
    "slug": null,
    "description": null
}
```

Please see the below tables for the different values that can populate these fields. They are separated by journey and with notes to explain how the status could get returned, with advice on how to fix issues.

**Journey:**

- Add

| State  | Slug        | Description | Notes      | Corrective Action |
| ------ | ----------- | ----------- | ---------- | ----------------- |
| pending | `WALLET_ONLY` | No authorisation provided | Using `POST /loyalty_cards/add` to add a Store type Loyalty Card to the user's wallet. | No error state here, this is expected when adding a Loyalty Card as Store type. |

**Journey:**

- Add and Authorise
- Authorise

| State  | Slug        | Description | Notes      | Corrective Action |
| ------ | ----------- | ----------- | ---------- | ----------------- |
| pending | `null` | null | Authorisation request has been sent and is waiting for a response from the merchant. | No action required, status will be updated. |
| failed | `ADD_FIELD` | Add data rejected by merchant. | `add_fields` submitted were rejected by the merchant. | User must remove the Loyalty Card and add it again. |
| failed | `AUTHORISATION_FAILED` | Authorisation data rejected by merchant | `authorise_fields` submitted were rejected by the merchant. | User must re-enter `authorise_fields` using endpoint `PUT /loyalty_cards/{loyalty_card_id}/authorise`. |
| unauthorised | `AUTHORISATION_FAILED` | Authorisation data rejected by merchant | A non-recoverable internal error occurred when trying to authorise this Loyalty Card. | Something unespected has happened. First get the user to delete and re-add the Loyalty Card. If the issue persists contact Bink support. |
| failed | `ACCOUNT_DOES_NOT_EXIST` | Account does not exist | Merchant didn’t find a loyalty account with these details. | Use the Join journey using endpoint `POST /loyalty_cards/join`. |
| failed | `ACCOUNT_NOT_REGISTERED` | Account not registered | Card added was a Ghost Card not yet registered with the merchant. | Use the Register journey using endpoint `POST /loyalty_cards/{loyalty_card_id}/register`. |
| unauthorised | `AUTHORISATION_EXPIRED` | Authorisation expired | The merchant has notified us the authorisation details on this account has been expired and needs to be reset. | The user must contact the merchant directly to reset the loyalty account details. |
| failed | `UPDATE_FAILED` | Update failed, delete and re-add card   | Status only appears when trying update Loyalty Card `authorise_fields`. This signifies that an email or other unique identifying credential has conflicted with an existing Loyalty Card. | User needs to delete this card and go through the Add and Authorise journey using the endpoint `POST /loyalty_cards/add_and_authorise`. |

**Journey:**

- Join

| State  | Slug        | Description | Notes      | Corrective Action |
| ------ | ----------- | ----------- | ---------- | ----------------- |
| pending | `JOIN_IN_PROGRESS` | null | Join request has been submitted and is waiting for response from the merchant. | No action required, status will be updated. |
| authorised | `null` | null | Join successfully completed with merchant. | No action required. The join resource will now be a Loyalty Card. |
| failed | `JOIN_FAILED` | Join data rejected by merchant | Join request has been rejected by the merchant. | Must start another Join journey using endpoint `POST /loyalty_cards/join`. Failed Joins must be deleted by the user. |
| failed | `ACCOUNT_ALREADY_EXISTS` | An account already exists | Merchant has responded saying the Join credentials already belong to an existing user. | User must go through the Add and Authorise journey using the endpoint `POST /loyalty_cards/add_and_authorise`. |

**Journey:**

- Register

| State  | Slug        | Description | Notes      | Corrective Action |
| ------ | ----------- | ----------- | ---------- | ----------------- |
| pending | `REGISTRATION_IN_PROGRESS` | null | Ghost card registration request has been submitted and is waiting for response from the merchant. | No action required, just wait for an update. |
| authorised | `null` | null | Ghost card registration successfully completed with merchant | No action required. |
| failed | `ACCOUNT_ALREADY_EXISTS` | An account already exists | Merchant has responded saying the Register credentials already belong to an existing user. | User must update the `authorise_fields` going through the Authorise journey using the endpoint `PUT /loyalty_cards/{loyalty_card_id}/authorise`. |
| failed | ACCOUNT_NOT_REGISTERED | Account not registered | Ghost card registration request has been rejected by the merchant | Something unespected has happened. First get the user to delete the Loyalty Card and retry the Registration journey. If the issue persists contact Bink support. |

## Statuses for PLL Links

Status gets returned through the API (GET /wallet ; GET /wallet/loyalty_cards/id) in the below structure:

```json
"status": {  
    "state": "active",
    "slug": null,
    "description": null
}
```

Please see the below table for the different values that can populate these fields. There are notes to explain how the status could get returned, with advice on how to fix issues.

| State  | Slug        | Description | Notes      | Corrective Action |
| ------ | ----------- | ----------- | ---------- | ----------------- |
| active | `null` | null | The PLL link is active. | No action required. |
| inactive | `PAYMENT_ACCOUNT_INACTIVE` | The Payment Account is not active so no PLL link can be created. | When the Payment Account is not active, no PLL link is created and the user will not earn loyalty by paying with that Payment Account. | User must delete and re-add the Payment Account. |
| pending | `PAYMENT_ACCOUNT_PENDING` | When the Payment Account becomes active, the PLL link will automatically go active. | While the Payment Account is pending the PLL link will not be active and the user will not earn loyalty by paying with that Payment Account. | No action required. Wait for the Payment Account to go into an active state. |
| inactive | `LOYALTY_CARD_NOT_AUTHORISED` | The Loyalty Card is not authorised so no PLL link can be created. | When the Loyalty Card is not authorised, there is no active PLL link. | User must resubmit the `auth_fields` for the Loyalty Card with `PUT /loyalty_cards/{loyalty_card_id}/authorise`. |
| inactive | `PAYMENT_ACCOUNT_AND_LOYALTY_CARD_INACTIVE` | The Payment Account and Loyalty Card are not active/authorised so no PLL link can be created.  | When the Loyalty Card is not authorised and the Payment Account is not active, no PLL link is created. | The user must do two things: Resubmit the `auth_fields` for the Loyalty Card with `PUT /loyalty_cards/{loyalty_card_id}/authorise`. Delete and re-add the Payment Account. |
| pending  | `LOYALTY_CARD_PENDING` | When the Loyalty Card becomes authorised, the PLL link will automatically go active. | While the Loyalty Card is pending the PLL link will not be active and the user will not earn loyalty on this Loyalty Card. | No action required. Wait for the Loyalty Card to go into an authorised state. |
| inactive | `UBIQUITY_COLLISION` | There is already a Loyalty Card from the same Loyalty Plan PLL linked to this Payment Account. | No two Loyalty Cards from the same Loyalty Plan can be PLL linked to the same Payment Account. There is no PLL link, so earned loyalty will not be applied to this Loyalty Card. Loyalty will be applied to the first Card from this Loyalty Plan added in another Wallet. | The user should remove the Loyalty Card and replace with the one that is PLL linked in another Wallet. |
