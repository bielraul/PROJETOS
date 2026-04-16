-- database: catalogo_whatsapp

CREATE DATABASE IF NOT EXISTS catalogo_whatsapp
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE catalogo_whatsapp;

-- ============================================================
-- USERS
-- ============================================================
CREATE TABLE users (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,
  email       VARCHAR(150) NOT NULL UNIQUE,
  password    VARCHAR(255) NOT NULL,
  role        ENUM('admin','editor') NOT NULL DEFAULT 'admin',
  active      TINYINT(1) NOT NULL DEFAULT 1,
  created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- CATEGORIES
-- ============================================================
CREATE TABLE categories (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,
  slug        VARCHAR(120) NOT NULL UNIQUE,
  description TEXT,
  active      TINYINT(1) NOT NULL DEFAULT 1,
  created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_slug (slug),
  INDEX idx_active (active)
) ENGINE=InnoDB;

-- ============================================================
-- PRODUCTS
-- ============================================================
CREATE TABLE products (
  id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  category_id       INT UNSIGNED NOT NULL,
  name              VARCHAR(200) NOT NULL,
  slug              VARCHAR(220) NOT NULL UNIQUE,
  short_description VARCHAR(500),
  description       TEXT,
  price             DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  promo_price       DECIMAL(10,2) DEFAULT NULL,
  brand             VARCHAR(100),
  model             VARCHAR(100),
  color             VARCHAR(80),
  stock             INT NOT NULL DEFAULT 0,
  main_image        VARCHAR(255),
  status            ENUM('active','inactive') NOT NULL DEFAULT 'active',
  featured          TINYINT(1) NOT NULL DEFAULT 0,
  created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_slug        (slug),
  INDEX idx_status      (status),
  INDEX idx_featured    (featured),
  INDEX idx_category_id (category_id),
  CONSTRAINT fk_products_category
    FOREIGN KEY (category_id) REFERENCES categories(id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- PRODUCT IMAGES (galeria)
-- ============================================================
CREATE TABLE product_images (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  product_id INT UNSIGNED NOT NULL,
  filename   VARCHAR(255) NOT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_product_id (product_id),
  CONSTRAINT fk_images_product
    FOREIGN KEY (product_id) REFERENCES products(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- DADOS INICIAIS
-- ============================================================

-- Admin: senha = Admin@123
INSERT INTO users (name, email, password, role) VALUES
('Administrador', 'admin@loja.com',
 '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin');

INSERT INTO categories (name, slug, description, active) VALUES
('Smartphones',   'smartphones',   'Celulares e smartphones',          1),
('Notebooks',     'notebooks',     'Computadores portáteis',           1),
('Acessórios',    'acessorios',    'Acessórios para eletrônicos',      1),
('Smart TVs',     'smart-tvs',     'Televisores inteligentes',         1),
('Fones de Ouvido','fones-de-ouvido','Headphones e earbuds',           1);

INSERT INTO products
  (category_id, name, slug, short_description, description,
   price, promo_price, brand, model, color, stock,
   main_image, status, featured)
VALUES
(1, 'iPhone 15 Pro Max 256GB',
 'iphone-15-pro-max-256gb',
 'O iPhone mais avançado da Apple com chip A17 Pro e câmera de 48MP.',
 '<p>O iPhone 15 Pro Max redefine o que um smartphone pode ser. Com o poderoso chip A17 Pro, sistema de câmeras profissional e tela Super Retina XDR de 6,7 polegadas, é a escolha perfeita para quem quer o melhor.</p><ul><li>Chip A17 Pro</li><li>Câmera principal 48MP</li><li>Bateria de longa duração</li><li>Titânio de grau aeroespacial</li></ul>',
 8999.90, 7999.90, 'Apple', 'iPhone 15 Pro Max', 'Titânio Natural', 15,
 NULL, 'active', 1),

(1, 'Samsung Galaxy S24 Ultra 512GB',
 'samsung-galaxy-s24-ultra-512gb',
 'Galaxy S24 Ultra com S Pen integrado e câmera de 200MP.',
 '<p>O Samsung Galaxy S24 Ultra é um smartphone Android completo com S Pen integrado, câmera de 200MP e processador Snapdragon 8 Gen 3.</p><ul><li>Tela Dynamic AMOLED 6,8"</li><li>Câmera 200MP</li><li>S Pen integrado</li><li>Bateria 5000mAh</li></ul>',
 7499.00, NULL, 'Samsung', 'Galaxy S24 Ultra', 'Titânio Preto', 8,
 NULL, 'active', 1),

(2, 'MacBook Air M3 8GB 256GB',
 'macbook-air-m3-8gb-256gb',
 'MacBook Air com chip M3, ultrafino e com autonomia de até 18h.',
 '<p>O MacBook Air com chip Apple M3 oferece desempenho excepcional em um design ultrafino. Com tela Liquid Retina de 13 polegadas e até 18 horas de bateria.</p>',
 9299.00, 8499.00, 'Apple', 'MacBook Air M3', 'Meia-Noite', 5,
 NULL, 'active', 1),

(3, 'AirPods Pro 2ª Geração',
 'airpods-pro-2a-geracao',
 'Cancelamento de ruído ativo, audio espacial e chip H2.',
 '<p>Os AirPods Pro de 2ª geração oferecem cancelamento de ruído ativo até 2x mais eficaz, áudio espacial personalizado e resistência à água IPX4.</p>',
 1899.00, 1599.00, 'Apple', 'AirPods Pro 2', 'Branco', 22,
 NULL, 'active', 1),

(4, 'Smart TV Samsung 65" QLED 4K',
 'smart-tv-samsung-65-qled-4k',
 'TV QLED 4K com Quantum Processor 4K e painel de 65 polegadas.',
 '<p>A Samsung QLED 4K de 65" entrega cores vibrantes com tecnologia Quantum Dot, processamento 4K inteligente e sistema operacional Tizen com acesso a todos os streamings.</p>',
 4799.00, NULL, 'Samsung', 'QN65Q80C', 'Preto', 3,
 NULL, 'active', 0),

(1, 'Xiaomi Redmi Note 13 Pro 256GB',
 'xiaomi-redmi-note-13-pro-256gb',
 'Redmi Note 13 Pro com câmera de 200MP e carregamento de 67W.',
 '<p>O Redmi Note 13 Pro une câmera de 200MP, tela AMOLED 120Hz e carregamento turbo de 67W em um smartphone com ótimo custo-benefício.</p>',
 1899.00, 1699.00, 'Xiaomi', 'Redmi Note 13 Pro', 'Verde Bosque', 30,
 NULL, 'active', 0),

(5, 'Sony WH-1000XM5 - Headphone Bluetooth',
 'sony-wh-1000xm5',
 'Melhor cancelamento de ruído do mercado com 30h de bateria.',
 '<p>O Sony WH-1000XM5 é o headphone com melhor cancelamento de ruído da categoria. Com 8 microfones e processador HD Noise Cancelling QN2, oferece silêncio absoluto onde você estiver.</p>',
 2299.00, 1999.00, 'Sony', 'WH-1000XM5', 'Preto', 0,
 NULL, 'active', 0);