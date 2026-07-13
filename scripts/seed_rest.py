import subprocess, json, urllib.request

TOKEN = subprocess.run(['gcloud', 'auth', 'print-access-token'], capture_output=True, text=True).stdout.strip()
BASE = 'https://firestore.googleapis.com/v1/projects/vendi-marketplace/databases/(default)/documents'

products = [
    ('iphone-15-pro', 'iPhone 15 Pro', 145000, 165000, 'phones', 'Apple Store Kenya', True, True, False, 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-15-pro-finish-select-202309-6-1inch-naturaltitanium?wid=5120'),
    ('samsung-s24-ultra', 'Samsung Galaxy S24 Ultra', 155000, 175000, 'phones', 'Samsung Kenya', True, True, True, 'https://images.samsung.com/is/image/samsung/p6pim/africa_en/2401/gallery/africa-en-galaxy-s24-s928-sm-s928bztqafc-539387384'),
    ('macbook-pro-16', 'MacBook Pro 16" M3 Pro', 320000, 320000, 'computers', 'Apple Store Kenya', True, False, False, 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/mbp16-spaceblack-select-202310'),
    ('sony-wh1000xm5', 'Sony WH-1000XM5', 38000, 42000, 'electronics', 'Audio World KE', True, True, True, 'https://www.sony.co.ke/image/5d02da5df552836db894cead8a68f5f3'),
    ('nike-air-max-90', 'Nike Air Max 90', 12500, 15000, 'fashion', 'Nike Kenya', False, True, False, 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/b1b5f2a8-6e7d-4fb4-b1c4-6e7b2d8c9f0a/air-max-90-shoes.png'),
    ('playstation-5', 'PlayStation 5', 85000, 95000, 'electronics', 'Game Zone KE', True, False, True, 'https://gmedia.playstation.com/is/image/SIEPDC/ps5-product-thumbnail-01-en-16nov23'),
    ('apple-watch-9', 'Apple Watch Series 9', 48000, 55000, 'electronics', 'Apple Store Kenya', False, True, False, 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/watch-card-40-s9-202309'),
    ('jbl-flip-6', 'JBL Flip 6', 12000, 14500, 'electronics', 'Audio World KE', True, False, False, 'https://www.jbl.co.ke/dw/image/v2/AAUJ_PRD/on/demandware.static/-/Sites-masterCatalog_Harman/default/dwf1b2c8e1/JBL_FLIP6_HERO_BLACK_48157_x2.png'),
    ('logitech-mx-keys', 'Logitech MX Keys', 14500, 14500, 'computers', 'Tech Accessories KE', False, False, False, 'https://resource.logitech.com/w_692,c_lpad,ar_4:3,q_auto,f_auto,dpr_1.0/d_transparent.gif/content/dam/logitech/en/products/mx/mx-keys/gallery/mx-keys-graphite-gallery-us.png'),
    ('anker-powercore', 'Anker PowerCore 20000', 5500, 7000, 'electronics', 'Tech Accessories KE', False, True, True, 'https://www.anker.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/a/1/a1278_1.jpg'),
]

count = 0
for (slug, name, price, oldPrice, cat, store, feat, best, flash, img) in products:
    data = {
        'fields': {
            'name': {'stringValue': name},
            'slug': {'stringValue': slug},
            'description': {'stringValue': name + ' - premium quality from ' + store},
            'price': {'integerValue': str(price)},
            'oldPrice': {'integerValue': str(oldPrice)},
            'images': {'arrayValue': {'values': [{'stringValue': img}]}},
            'category': {'stringValue': cat},
            'storeName': {'stringValue': store},
            'storeId': {'stringValue': 'store-1'},
            'tags': {'arrayValue': {'values': [{'stringValue': 'premium'}]}},
            'sku': {'stringValue': 'SKU-' + slug},
            'stock': {'integerValue': '50'},
            'isFeatured': {'booleanValue': feat},
            'isBestSeller': {'booleanValue': best},
            'isFlashSale': {'booleanValue': flash},
            'rating': {'doubleValue': 0},
            'reviewCount': {'integerValue': '0'},
        }
    }
    req = urllib.request.Request(
        f'{BASE}/products/{slug}',
        data=json.dumps(data).encode(),
        headers={'Authorization': f'Bearer {TOKEN}', 'Content-Type': 'application/json'},
        method='PATCH'
    )
    try:
        resp = json.loads(urllib.request.urlopen(req).read())
        if 'createTime' in resp:
            count += 1
            print(f'  OK: {name}')
    except Exception as e:
        print(f'  FAIL: {slug}: {e}')

print(f'\nProducts: {count}/{len(products)}')

coupons = [
    ('WELCOME10', 'percent', 10, '10% off first order'),
    ('SAVE20', 'percent', 20, '20% off electronics'),
    ('FREESHIP', 'free_shipping', 0, 'Free shipping'),
    ('FLAT500', 'fixed', 500, 'KSh 500 off'),
]
for (code, ctype, val, desc) in coupons:
    data = {
        'fields': {
            'code': {'stringValue': code},
            'type': {'stringValue': ctype},
            'value': {'integerValue': str(val)},
            'description': {'stringValue': desc},
            'isActive': {'booleanValue': True},
            'minOrderAmount': {'integerValue': '1000'},
            'maxUses': {'integerValue': '500'},
            'currentUses': {'integerValue': '0'},
        }
    }
    req = urllib.request.Request(
        f'{BASE}/coupons/{code}',
        data=json.dumps(data).encode(),
        headers={'Authorization': f'Bearer {TOKEN}', 'Content-Type': 'application/json'},
        method='PATCH'
    )
    urllib.request.urlopen(req)
    print(f'  Coupon: {code}')
print(f'\nCoupons: {len(coupons)}')
print('Done!')
