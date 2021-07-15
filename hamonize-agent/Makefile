all: build_node_app

build_node_app:
	@echo "Update node binary..." 
	
	cd src/ && \
	npm run clean && \
	npm install && \
	npm run build && \
	cp -v ./hamonize-agent ../usr/share/hamonize-agent/

clean:
	rm -fv usr/share/hamonize-agent/hamonize-agent 