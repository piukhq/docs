# Bink API Changelog

***

## 16/02/2022
1. Added full list for credential type.
2. Corrected example where is_acceptance_required = true for consents.

## 14/01/2022
1. Added wallet_overview endpoint
2. Added loyalty_plans_overview endpoint
3. Made email optional in POST /token
4. Added images to payment_accounts in GET /wallet
5. Added loyalty plan images to joins and loyalty_cards objects in GET /wallet
6. Changed "loyalty_plan_id" to "loyalty_card_id" in pll_links object in GET /wallet

## 15/02/2022
1. Added 'provider' to payment_accounts object in GET /wallet and GET /wallet_overview endpoints
2. Changed 'barcode_type' to integer in voucher object of GET /wallet and GET /loyalty_cards/{loyalty_card_id}/vouchers
3. Added 'is_in_wallet' field in GET /loyalty_plan_overview , GET /loyalty_plans and GET /loyalty_plan/{loyalty_plan_id} to indicate if the given user has a loyalty card of the loyalty plan in their wallet
4. Documentation updates: general formatting and examples updated
