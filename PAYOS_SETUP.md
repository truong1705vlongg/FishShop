# PayOS checkout

Checkout offers two choices: cash on delivery, and bank transfer through PayOS. New bank transfer orders show PayOS Checkout embedded in the right-hand panel of the FishShop payment page. Existing manual bank transfer orders remain manually confirmed by the shop. Cash is collected on delivery and must be marked paid by staff after collection. PayOS is marked paid only by a valid PayOS webhook with the matching amount and order code; the return URL alone never marks an order paid.

## Credentials to configure

Create and verify a PayOS merchant account/channel at https://my.payos.vn. Copy `.env.example` to `.env` and set `PAYOS_CLIENT_ID`, `PAYOS_API_KEY`, and `PAYOS_CHECKSUM_KEY`. The local `.env` is ignored by Git. Never commit credentials or paste them into chat. `config/payos.php` reads `.env` and lets server environment variables override it.

The repository includes a `.githooks/pre-push` secret guard. It is enabled in the development clone with `git config core.hooksPath .githooks`; repeat this command in any other clone. GitHub does not receive local Git hooks, so also enable GitHub Secret Scanning and Push Protection in the repository settings for server-side blocking.

Set `FISHSHOP_PUBLIC_URL` to the public HTTPS base address of this shop, with no trailing slash; for example `https://shop.example.com`. `localhost` cannot receive PayOS webhooks. Expose `/payos_webhook.php` publicly over HTTPS, then set that full URL as the channel webhook URL in PayOS. PayOS requires a publicly reachable URL and verifies it when configuring the channel. Return and cancel links are built from this same public base URL.

For local-only development, use a public HTTPS tunnel to the local FishShop Apache instance and set that tunnel's base URL temporarily; do not use the localhost default for real payments.

## Database

Select `WebBanCa` in phpMyAdmin and run `database/PayOS.sql` once. Existing orders default to `bank_transfer`, so they keep their current behavior. New columns hold the chosen method and PayOS link metadata.

## Behavior

- PayOS payment amount is recalculated from the server's order total. Each payment attempt gets a fresh PayOS order code; its payment link ID is matched back to the FishShop order for webhook confirmation. Transfer content is `FS` followed by the FishShop order ID.
- The API request signature and webhook signature use the PayOS checksum key. TLS certificate checks remain enabled.
- A successful webhook is idempotent. It must match the order amount; cancelled orders are not marked paid.
- A browser return from PayOS displays a pending/updated status. The signed webhook is the source of truth.
- Current PayOS minimum and maximum are enforced at link creation (2,000–500,000,000 VND).
- Cash remains unpaid in the database until staff confirms collection in the admin order page.

Official docs: https://payos.vn/docs/api/ , https://payos.vn/docs/du-lieu-tra-ve/webhook/ , https://payos.vn/docs/tich-hop-webhook/kiem-tra-du-lieu-voi-signature/
