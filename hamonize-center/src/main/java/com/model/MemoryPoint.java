package com.model;

import java.time.Instant;

import org.influxdb.annotation.Column;
import org.influxdb.annotation.Measurement;




@Measurement(name = "memory")
public class MemoryPoint {
 
    @Column(name = "time")
    private Instant time;
 
    @Column(name = "host")
    private Instant host;

    @Column(name = "type")
    private Instant type;

    @Column(name = "type_instance")
    private Instant type_instance;
    
    @Column(name = "value")
    private Instant value;
    
    @Column(name = "name")
    private String name;
 
    @Column(name = "free")
    private Long free;
 
    @Column(name = "used")
    private Long used;
 
    @Column(name = "buffer")
    private Long buffer;

	public Instant getTime() {
		return time;
	}

	public void setTime(Instant time) {
		this.time = time;
	}

	public Instant getHost() {
		return host;
	}

	public void setHost(Instant host) {
		this.host = host;
	}

	public Instant getType() {
		return type;
	}

	public void setType(Instant type) {
		this.type = type;
	}

	public Instant getType_instance() {
		return type_instance;
	}

	public void setType_instance(Instant type_instance) {
		this.type_instance = type_instance;
	}

	public Instant getValue() {
		return value;
	}

	public void setValue(Instant value) {
		this.value = value;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Long getFree() {
		return free;
	}

	public void setFree(Long free) {
		this.free = free;
	}

	public Long getUsed() {
		return used;
	}

	public void setUsed(Long used) {
		this.used = used;
	}

	public Long getBuffer() {
		return buffer;
	}

	public void setBuffer(Long buffer) {
		this.buffer = buffer;
	}
}