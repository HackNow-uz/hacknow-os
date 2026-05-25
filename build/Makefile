.PHONY: all clean config build rebuild test help

# Default target
all: build

clean:
	sudo lb clean --purge
	rm -rf .build cache chroot binary build.log

config:
	lb config

build: config
	sudo lb build 2>&1 | tee build.log

rebuild: clean build

test:
	@ISO=$$(ls -t *.iso 2>/dev/null | head -1); \
	if [ -z "$$ISO" ]; then \
		echo "ISO topilmadi. Avval: make build"; \
		exit 1; \
	fi; \
	echo "QEMU da test: $$ISO"; \
	qemu-system-x86_64 -m 2048 -cdrom "$$ISO" -boot d -vga virtio -display gtk -enable-kvm 2>/dev/null || \
	qemu-system-x86_64 -m 2048 -cdrom "$$ISO" -boot d -vga std

sha256:
	@ISO=$$(ls -t *.iso 2>/dev/null | head -1); \
	if [ -n "$$ISO" ]; then \
		sha256sum "$$ISO"; \
	else \
		echo "ISO topilmadi"; \
	fi

help:
	@echo ""
	@echo "HackNow OS Build System"
	@echo "======================="
	@echo ""
	@echo "Buyruqlar:"
	@echo "  make build    - ISO yaratish (config + build)"
	@echo "  make rebuild  - Tozalash + config + build"
	@echo "  make clean    - Build qoldiqlarini tozalash"
	@echo "  make config   - Faqat konfiguratsiya"
	@echo "  make test     - QEMU da ISO ni test qilish"
	@echo "  make sha256   - ISO SHA256 chiqarish"
	@echo "  make help     - Yordam"
	@echo ""
	@echo "Talab: sudo make build"
	@echo ""
