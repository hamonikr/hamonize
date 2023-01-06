all: build_node_app

build_node_app:
	@echo "Update node binary..." 
	
	
	cd src/ && \
	npm run clean && \
	npm install && \
	npm run build:linux && \
	cp -v ./dist/hamonize-connect-1.0.0.AppImage ../usr/local/hamonize-connect/hamonize-connect
	

clean:
	rm -fv usr/share/hamonize-connect/*
	
