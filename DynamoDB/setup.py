import boto3

endpoint_url = "http://localhost.localstack.cloud:4566"

user_info = [
    ("admin_user", "password123", "admin_user@example.com", " ", "admin"),
    (
        "customer1",
        "password123",
        "customer1@example.com",
        "123 Main St, Anytown, CA 12345",
        "customer",
    ),
]

product_info = [
    (
        "Samsung Q90T QLED TV",
        "Smart TV",
        1999.99,
        "A high-end QLED TV with excellent picture quality and smart features.",
        "smart_tv1.jpg",
        100,
    ),
    (
        "LG CX OLED TV",
        "Smart TV",
        2499.99,
        "A top-of-the-line OLED TV with stunning contrast and deep blacks.",
        "smart_tv2.jpg",
        100,
    ),
    (
        "Sony X900H LED TV",
        "Smart TV",
        1599.99,
        "A premium LED TV with impressive brightness and vibrant colors.",
        "smart_tv3.jpg",
        100,
    ),
    (
        "TCL 6-Series Roku TV",
        "Smart TV",
        799.99,
        "An affordable smart TV with great picture quality and Roku OS.",
        "smart_tv4.jpg",
        75,
    ),
    (
        "Vizio M-Series Quantum TV",
        "Smart TV",
        699.99,
        "A budget-friendly Quantum Dot TV with good color reproduction.",
        "smart_tv5.jpg",
        121,
    ),
    (
        "Hisense H8G Quantum TV",
        "Smart TV",
        899.99,
        "A mid-range Quantum Dot TV with excellent HDR performance.",
        "smart_tv6.jpg",
        121,
    ),
    (
        "Samsung TU8000 Crystal UHD TV",
        "Smart TV",
        599.99,
        "An entry-level Crystal UHD TV with decent picture quality and smart features.",
        "smart_tv7.jpg",
        65,
    ),
    (
        "Sony X950H LED TV",
        "Smart TV",
        1799.99,
        "A high-end LED TV with excellent upscaling and motion handling.",
        "smart_tv8.jpg",
        75,
    ),
    (
        "Canon EOS Rebel T7",
        "Camera",
        499.99,
        "An entry-level DSLR camera with good image quality and easy-to-use features.",
        "camera1.jpg",
        121,
    ),
    (
        "Nikon D3500",
        "Camera",
        449.99,
        "A beginner-friendly DSLR camera with excellent battery life and image quality.",
        "camera2.jpg",
        87,
    ),
    (
        "Sony Alpha a6000",
        "Camera",
        599.99,
        "A mirrorless camera with a compact design, fast autofocus, and good image quality.",
        "camera3.jpg",
        43,
    ),
    (
        "Fujifilm X-T4",
        "Camera",
        1699.99,
        "A high-end mirrorless camera with excellent image stabilization and video recording capabilities.",
        "camera4.jpg",
        75,
    ),
    (
        "Canon PowerShot G7 X Mark III",
        "Camera",
        749.99,
        "A compact camera with a large sensor, good low-light performance, and 4K video recording.",
        "camera5.jpg",
        99,
    ),
    (
        "Nikon Z6",
        "Camera",
        1999.99,
        "A full-frame mirrorless camera with great image quality, low-light performance, and 4K video recording.",
        "camera6.jpg",
        75,
    ),
    (
        "Sony Cyber-shot DSC-RX100 VII",
        "Camera",
        1299.99,
        "A premium compact camera with a large sensor, fast autofocus, and 4K video recording.",
        "camera7.jpg",
        99,
    ),
    (
        "Panasonic Lumix DC-S1",
        "Camera",
        1999.99,
        "A full-frame mirrorless camera with excellent image quality, 4K video, and rugged build.",
        "camera8.jpg",
        75,
    ),
    (
        "iPhone 13 Pro",
        "Phone",
        999.99,
        "Apple"
        "s flagship phone with a ProMotion display, A15 Bionic chip, and improved cameras.",
        "phone1.jpg",
        75,
    ),
    (
        "Samsung Galaxy S21 Ultra",
        "Phone",
        1199.99,
        "Samsung"
        "s premium phone with a large AMOLED display, S Pen support, and versatile cameras.",
        "phone2.jpg",
        148,
    ),
    (
        "Google Pixel 6 Pro",
        "Phone",
        899.99,
        "Google"
        "s latest phone with a Tensor chip, improved cameras, and a high-refresh-rate display.",
        "phone3.jpg",
        99,
    ),
    (
        "OnePlus 9 Pro",
        "Phone",
        1069.99,
        "OnePlus"
        " flagship phone with a Hasselblad-tuned camera system, Snapdragon 888 chip, and fast charging.",
        "phone4.jpg",
        99,
    ),
    (
        "Xiaomi Mi 11 Ultra",
        "Phone",
        1199.99,
        "Xiaomi"
        "s flagship phone with a large AMOLED display, Snapdragon 888 chip, and a versatile camera setup.",
        "phone5.jpg",
        148,
    ),
    (
        "Sony Xperia 1 III",
        "Phone",
        1299.99,
        "Sony"
        "s flagship phone with a 4K OLED display, Snapdragon 888 chip, and a triple-camera system.",
        "phone6.jpg",
        99,
    ),
    (
        "Samsung Galaxy Z Fold 3",
        "Phone",
        1799.99,
        "Samsung"
        "s foldable phone with an improved design, larger cover display, and S Pen support.",
        "phone7.jpg",
        148,
    ),
    (
        "Apple iPhone SE (2020)",
        "Phone",
        399.99,
        "Apple"
        "s budget-friendly iPhone with the A13 Bionic chip, Touch ID, and a compact design.",
        "phone8.jpg",
        148,
    ),
    (
        "Apple MacBook Pro 16-inch",
        "Laptop",
        2399.99,
        "Apple"
        "s flagship laptop with a 16-inch Retina display, M1 Pro/Max chip, and up to 64GB RAM.",
        "laptop1.jpg",
        75,
    ),
    (
        "Dell XPS 13",
        "Laptop",
        1099.99,
        "Dell"
        "s premium ultrabook with a 13.4-inch InfinityEdge display, 11th Gen Intel Core processors, and excellent build quality.",
        "laptop2.jpg",
        99,
    ),
    (
        "HP Spectre x360",
        "Laptop",
        1399.99,
        "HP"
        "s premium 2-in-1 laptop with a 13.3-inch OLED display, 11th Gen Intel Core processors, and a convertible design.",
        "laptop3.jpg",
        99,
    ),
    (
        "Microsoft Surface Laptop 4",
        "Laptop",
        999.99,
        "Microsoft"
        "s sleek laptop with a 13.5-inch PixelSense display, 11th Gen Intel Core processors, and a premium design.",
        "laptop4.jpg",
        121,
    ),
    (
        "Lenovo ThinkPad X1 Carbon Gen 9",
        "Laptop",
        1699.99,
        "Lenovo"
        "s business-focused laptop with a 14-inch display, 11th Gen Intel Core processors, and legendary ThinkPad durability.",
        "laptop5.jpg",
        133,
    ),
    (
        "Asus ZenBook 13",
        "Laptop",
        799.99,
        "Asus"
        "s ultraportable laptop with a 13.3-inch display, 11th Gen Intel Core processors, and a slim and lightweight design.",
        "laptop6.jpg",
        168,
    ),
    (
        "Razer Blade 15",
        "Laptop",
        1999.99,
        "Razer"
        "s gaming laptop with a 15.6-inch display, up to an Intel Core i9 processor, and NVIDIA GeForce RTX graphics.",
        "laptop7.jpg",
        5,
    ),
    (
        "Acer Swift 5",
        "Laptop",
        899.99,
        "Acer"
        "s lightweight laptop with a 14-inch display, 11th Gen Intel Core processors, and a magnesium-lithium chassis.",
        "laptop8.jpg",
        121,
    ),
]


def setup():
    dynamodb = boto3.resource("dynamodb", endpoint_url=endpoint_url)

    # Create users table
    users_table = dynamodb.create_table(
        TableName="users",
        KeySchema=[{"AttributeName": "id", "KeyType": "HASH"}],
        AttributeDefinitions=[{"AttributeName": "id", "AttributeType": "N"}],
        ProvisionedThroughput={"ReadCapacityUnits": 10, "WriteCapacityUnits": 10},
    )

    # Create products table
    products_table = dynamodb.create_table(
        TableName="products",
        KeySchema=[{"AttributeName": "id", "KeyType": "HASH"}],
        AttributeDefinitions=[{"AttributeName": "id", "AttributeType": "N"}],
        ProvisionedThroughput={"ReadCapacityUnits": 10, "WriteCapacityUnits": 10},
    )

    # Create sales table
    sales_table = dynamodb.create_table(
        TableName="sales",
        KeySchema=[{"AttributeName": "id", "KeyType": "HASH"}],
        AttributeDefinitions=[
            {"AttributeName": "id", "AttributeType": "N"},
        ],
        ProvisionedThroughput={"ReadCapacityUnits": 40, "WriteCapacityUnits": 50},
    )

    # Create orders table
    orders_table = dynamodb.create_table(
        TableName="orders",
        KeySchema=[{"AttributeName": "id", "KeyType": "HASH"}],
        AttributeDefinitions=[{"AttributeName": "id", "AttributeType": "N"}],
        ProvisionedThroughput={"ReadCapacityUnits": 50, "WriteCapacityUnits": 50},
    )

    # Wait for tables to be created
    users_table.wait_until_exists()
    products_table.wait_until_exists()
    sales_table.wait_until_exists()
    orders_table.wait_until_exists()

    # Insert data into users table
    users_data = [
        {
            "id": i + 1,
            "username": {"S": user_info[i][0]},
            "password": {"S": user_info[i][1]},
            "email": {"S": user_info[i][2]},
            "shipping_address": {"S": user_info[i][3]},
            "role": {"S": user_info[i][4]},
        }
        for i in range(len(user_info))
    ]
    dynamodb.batch_write_item(
        RequestItems={"users": [{"PutRequest": {"Item": item}} for item in users_data]}
    )

    # Insert data into products table
    products_data = [
        {
            "id": i + 1,
            "name": {"S": product_info[i][0]},
            "category": {"S": product_info[i][1]},
            "price": {"N": str(product_info[i][2])},
            "description": {"S": product_info[i][3]},
            "image_filename": {"S": product_info[i][4]},
            "quantity": {"N": str(product_info[i][5])},
        }
        for i in range(len(product_info))
    ]
    for j in range(0, len(products_data), 10):
        dynamodb.batch_write_item(
            RequestItems={
                "products": [{"PutRequest": {"Item": item}} for item in products_data[j:j + 10]]
            }
        )

    print("Tables and data created successfully.")


setup()
