# Hướng dẫn cài đặt SmartPro Vuln LLM Agent

Hướng dẫn này mô tả cách cài đặt và khởi chạy dự án **SmartPro Vuln LLM Agent** bằng Docker Compose.

---

## Mục lục

1. [Yêu cầu hệ thống](#yêu-cầu-hệ-thống)
2. [Tải mã nguồn](#tải-mã-nguồn)
3. [Cấu hình file môi trường `.env`](#cấu-hình-file-môi-trường-env)
   - [Cách 1: Dùng Ollama Local (Offline)](#cách-1-dùng-ollama-local-offline)
   - [Cách 2: Dùng OpenRouter API (Online)](#cách-2-dùng-openrouter-api-online)
4. [Khởi chạy bằng Docker Compose](#khởi-chạy-bằng-docker-compose)
5. [Quản lý container](#quản-lý-container)
6. [Xử lý sự cố thường gặp](#xử-lý-sự-cố-thường-gặp)

---

## Yêu cầu hệ thống

Trước khi bắt đầu, hãy đảm bảo máy bạn đã cài đặt:

| Công cụ | Phiên bản tối thiểu | Hướng dẫn cài đặt |
|---------|--------------------|--------------------|
| Docker Engine | 24.0+ | [Cài Docker](https://docs.docker.com/engine/install/) |
| Docker Compose Plugin | 2.0+ | `sudo apt install docker-compose-v2` |
| Git | Bất kỳ | `sudo apt install git` |

> [!NOTE]
> Nếu bạn muốn dùng **Ollama Local** thay vì OpenRouter, hãy cài thêm [Ollama](https://ollama.com/download) trên máy host.

---

## Tải mã nguồn

Mở Terminal và chạy các lệnh sau:

```bash
git clone https://github.com/your-org/smartpro-vuln-llm-agent.git
cd smartpro-vuln-llm-agent
```

Hoặc nếu bạn đã có mã nguồn, hãy điều hướng vào thư mục dự án:

```bash
cd smartpro-vuln-llm-agent
```

---

## Cấu hình file môi trường `.env`

Tạo file `.env` từ template mẫu:

```bash
cp .env.example .env
```

> [!IMPORTANT]
> Nếu không có file `.env.example`, hãy tạo file `.env` mới và điền nội dung theo hướng dẫn bên dưới.

Mở file `.env` bằng trình soạn thảo:

```bash
nano .env
# hoặc
code .env
```

---

### Cách 1: Dùng Ollama Local (Offline)

Phù hợp khi bạn muốn chạy mô hình AI hoàn toàn trên máy tính của mình, không cần kết nối internet sau khi tải mô hình.

**Bước 1**: Tải mô hình về máy (chỉ cần làm một lần):

```bash
ollama pull mistral-nemo
```

> [!NOTE]
> Mô hình `mistral-nemo` có dung lượng khoảng 7GB. Bạn có thể chọn mô hình nhỏ hơn như `qwen2.5:3b` (khoảng 2GB) nếu máy yếu.

**Bước 2**: Cấu hình file `.env`:

```env
# Chọn model Ollama
model_name="ollama/mistral-nemo"

# Địa chỉ Ollama Server
# LƯU Ý: Khi chạy trong Docker, phải dùng host.docker.internal thay cho localhost
OLLAMA_HOST=http://host.docker.internal:11434
```

---

### Cách 2: Dùng OpenRouter API (Online)

Phù hợp khi bạn muốn dùng các mô hình AI mạnh (GPT-4o, Gemini, Mistral, v.v.) qua Internet mà không cần tải về máy.

**Bước 1**: Đăng ký tài khoản và lấy API Key tại [openrouter.ai](https://openrouter.ai).

**Bước 2**: Cấu hình file `.env`:

```env
# Chọn model OpenRouter (xem danh sách tại openrouter.ai/models)
model_name="openrouter/mistralai/mistral-nemo"

# API Key của bạn
OPENROUTER_API_KEY="sk-or-v1-your-api-key-here"
```

> [!TIP]
> Một số model OpenRouter có thể dùng miễn phí (có nhãn `:free`):
> - `openrouter/meta-llama/llama-3-8b-instruct:free`
> - `openrouter/mistralai/mistral-7b-instruct:free`

---

## Khởi chạy bằng Docker Compose

Sau khi đã cấu hình file `.env`, chạy lệnh sau để build image và khởi động container:

```bash
docker compose up -d --build
```

Trong đó:
- `-d` (detach): Chạy container ở chế độ nền
- `--build`: Tự động rebuild image nếu có thay đổi trong mã nguồn

**Kiểm tra container đã khởi động thành công:**

```bash
docker compose ps
```

Kết quả mong đợi:

```
NAME                      STATUS
smartpro-vuln-llm-agent   Up 30 seconds (healthy)
```

**Truy cập giao diện ứng dụng:**

Mở trình duyệt và truy cập địa chỉ:

```
http://localhost:8501
```

---

## Quản lý container

| Lệnh | Mô tả |
|------|-------|
| `docker compose up -d` | Khởi động container |
| `docker compose down` | Dừng và xóa container |
| `docker compose restart` | Khởi động lại container |
| `docker compose logs -f` | Theo dõi log realtime |
| `docker compose ps` | Xem trạng thái container |
| `docker compose pull` | Tải phiên bản image mới nhất |

**Cập nhật lên phiên bản mới nhất từ Docker Hub:**

```bash
docker compose pull
docker compose up -d
```

---

## Xử lý sự cố thường gặp

### ❌ Lỗi: Cannot connect to Ollama

```
APIConnectionError: Connection refused to http://localhost:11434
```

**Nguyên nhân**: Container không thể kết nối đến Ollama chạy trên máy host.

**Giải pháp**: Đổi `OLLAMA_HOST` trong `.env` từ `localhost` sang `host.docker.internal`:

```env
OLLAMA_HOST=http://host.docker.internal:11434
```

---

### ❌ Lỗi: Model not found

```
OllamaError: model 'mistral-nemo' not found
```

**Giải pháp**: Tải model về máy trước:

```bash
ollama pull mistral-nemo
```

---

### ❌ Lỗi: OpenRouter API Key invalid

```
AuthenticationError: Invalid API key
```

**Giải pháp**: Kiểm tra lại `OPENROUTER_API_KEY` trong file `.env`. Đảm bảo không có khoảng trắng thừa và key còn hiệu lực trên trang [openrouter.ai/settings/keys](https://openrouter.ai/settings/keys).

---

### ❌ Lỗi: Port 8501 already in use

```
Error: bind: address already in use
```

**Giải pháp**: Đổi port mapping trong `docker-compose.yml`:

```yaml
ports:
  - "8502:8501"   # đổi 8501 thành cổng khác, ví dụ 8502
```

Sau đó truy cập tại `http://localhost:8502`.
