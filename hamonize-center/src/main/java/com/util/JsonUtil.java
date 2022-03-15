package com.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.io.IOException;

public final class JsonUtil {
    private static final Log LOGGER = LogFactory.getLog(JsonUtil.class);

    private JsonUtil() {

    }

    public static <T> String objectToJson(T obj) {
        ObjectMapper mapper = new ObjectMapper();
        try {
            return mapper.writeValueAsString(obj);
        } catch (JsonProcessingException e) {
            LOGGER.error(e);
            return null;
        }
    }

    public static JsonNode strToJsonObject(String data) {
        ObjectMapper mapper = new ObjectMapper();
        try {
            return mapper.readTree(data);
        } catch (IOException e) {
            LOGGER.error(e);
            return null;
        }
    }

    public static ObjectNode createObjectNode() {
        ObjectMapper mapper = new ObjectMapper();
        return mapper.createObjectNode();
    }

    public static ArrayNode createArrayNode() {
        ObjectMapper mapper = new ObjectMapper();
        return mapper.createArrayNode();
    }
}
