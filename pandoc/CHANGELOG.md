---
title: Changelog
output: html_document
---
## 17-05-2022

- Added the following fields to GET `/wallet_overview` endpoint:
    - `is_fully_pll_linked`
    - `pll_linked_payment_accounts`
    - `total_payment_accounts`
- Added the following fields to `loyalty_cards.pll_links` and `payment_accounts.pll_links` objects in GET `/wallet` endpoint:
    -  `state`
    -  `slug`
    -  `description`

## 25-04-2022

- Added Changelog and Appendix files

## 28-03-2022

- Added the following fields to `payment_accounts` object in `GET /wallet` and `GET /wallet_overview`: 
    - `issuer`
    - `type`
    - `country`
    - `currency_code`
    - `last_four_digits`
- Added `target_value` to balance object and changed `value` to `current_value` in `GET /wallet`, `GET /wallet_overview`, and `GET /wallet/loyalty_cards/{loyalty_card_id}`.
- Added `is_scannable` field to all credential fields in `GET /loyalty_plans`, `GET /loyalty_plans/{loyalty_plan_id}`, and `GET /loyalty_plans/{loyalty_plan_id}/journey_fields` to indicate if a credential field can be scanned, such as a barcode.
- Added GET `/loyalty_plans/{loyalty_plan_id}/plan_details` endpoint.


## 10-03-2022

- Split out `current_display_value` into consituent parts in balance object of wallet endpoints.
- Added card object to `GET /wallet_overview`.
- Added reward_available to `GET /wallet_overview` to indicate if there is an issued reward available for the given loyalty card.
- Added `GET /wallet/loyalty_cards/{loyalty_card_id}` to retrieve a single loyalty card from the wallet.
- Added functionality to limit displaying non-issued vouchers to no more than 10.

## 16-02-2022

- Added full list for credential type.
- Corrected example where `is_acceptance_required = true` for consents.

## 15-02-2022

- Added `provider` to `payment_accounts` object in `GET /wallet` and `GET /wallet_overview` endpoints.
- Changed `barcode_type` to integer in voucher object of `GET /wallet` and `GET /loyalty_cards/{loyalty_card_id}/vouchers`.
- Added `is_in_wallet` field in `GET /loyalty_plan_overview`, `GET /loyalty_plans`, and `GET /loyalty_plan/{loyalty_plan_id}` to indicate if the given user has a loyalty card of the loyalty plan in their wallet.
- Documentation updates: general formatting and examples updated.

## 14-01-2022

- Added `wallet_overview` endpoint.
- Added `loyalty_plans_overview` endpoint.
- Made email optional in `POST /token`.
- Added images to payment_accounts in `GET /wallet`.
- Added loyalty plan images to joins and `loyalty_cards` objects in `GET /wallet`.
- Changed `loyalty_plan_id` to `loyalty_card_id` in `pll_links` object in `GET /wallet`.
