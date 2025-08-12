;; Art Gallery NFT Contract
;; A simple NFT contract for representing artworks in a gallery.

;; Define NFT type
(define-non-fungible-token art-gallery-nft uint)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-id (err u101))
(define-constant err-token-exists (err u102))

;; Mapping for token metadata (URI of artwork)
(define-map token-uri-map uint (string-ascii 256))

;; Mint a new artwork NFT (Only Owner)
(define-public (mint-art (token-id uint) (uri (string-ascii 256)) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (> token-id u0) err-invalid-id)
    (asserts! (is-none (nft-get-owner? art-gallery-nft token-id)) err-token-exists)
    (try! (nft-mint? art-gallery-nft token-id recipient))
    (map-set token-uri-map token-id uri)
    (ok {token-id: token-id, uri: uri, owner: recipient})
  )
)

;; Get token URI (metadata of the artwork)
(define-read-only (get-token-uri (token-id uint))
  (ok (map-get? token-uri-map token-id)))