all: build_node_app

build_node_app:
	@echo "Update node binary..." 
	
	cd src/ && \
	npm run clean && \
	npm install && \
	npm run build && \
	cp -v ./dist/hamonize-agent ../usr/share/hamonize-agent/ && \
	cp -r ./shell ../usr/share/hamonize-agent/

clean:
	rm -fv usr/share/hamonize-agent/hamonize-agent 