package com.util;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Collection;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Set;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * <pre>
 * com.skt.tvalley.web.common.DataMap.java
 * DESC: 클래스설명.
 * </pre>
 * @author  kbchoi
 * @since   2015. 9. 10.
 * @version 1.0
 *
 */
public class DataMap extends LinkedHashMap<String, Object> implements Serializable {

	static final long serialVersionUID = 8180203168113225298L;
	
	private static final Logger log = LoggerFactory.getLogger(DataMap.class);

	protected String name = null;
	
	/**
	 * .
	 */
	public DataMap() {
	    super(500);
	}

	/**
	 * @param size
	 */
	public DataMap(int size) {
		super(size);
	}

	/**
	 * @param name
	 */
	public DataMap(String name) {
		this.name = name;
	}
	
	public String getName() {
	    return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}
		
	public void set(String key, Object value) {
		super.put(key, value);
	}

	public Object get(String name) {
		return (Object) super.get(name);
	}
	
	public void put(String name, String value) {
		if(value == null) {
			super.put(name, "");			
		}
		else {
			super.put(name, new String(value));
		}
	}
	
	public void put(String name, int value) {
		super.put(name, new Integer(value));
	}

	public void put(String name, long value) {
    	super.put(name, new Long(value));
	}

	public void put(String name, float value) {
		super.put(name, new Float(value));
	}

	public void put(String name, double value) {
		super.put(name, new Double(value));
	}

	public void put(String name, boolean value) {
		super.put(name, new Boolean(value));
	}
	
	public String getString(String name) {
	    Object obj = super.get(name);
	    
	    if(obj == null) {
	    	return null;
	    }
	    
	    if((obj instanceof Collection<?>) || (obj instanceof Object[])) {
	    	log.debug("A value type does not match String data type.");
	    }	    
	    
	    return obj.toString();
	}
	
	public String getString(String name, String defaultValue) {
		String str = getString(name);
		
	    if(str == null || "".equals(str)) {
	    	return defaultValue;
	    }

	    return str;
	}

	public int getInt(String name) {
		String value = getString(name);
	    return ((value == null || "".equals(value)) ? 0 : Integer.parseInt(value));
	}

	public long getLong(String name) throws NumberFormatException, Exception {
	    String value = getString(name);
	    return (value == null ? 0L : Long.parseLong(value));
	}

	public boolean getBoolean(String name) {
	    String value = getString(name);
	    
	    if(value == null) {
	    	return false;
	    }
	    else {
	    	boolean isBlank = false;
	    	
	    	if(value == null || value.trim().length() <= 0) {
	    		isBlank = true;
	    	}
	
	    	if(isBlank) {
	    		return false;
	    	}
	    	else {
	    		if(value.equalsIgnoreCase("true")) {
	    			return true;
	    		}
	    		else {
	    			return false;
	    		}
	    	}
	    }
	}

	@SuppressWarnings("rawtypes")
    public double getDouble(String name) {
    	Object object = super.get(name);
        
    	if(object != null) {
    		Class clazz = object.getClass();
            
            if(clazz == Double.class) {
            	return ((Double) object).doubleValue();
            }
            else if(clazz == Float.class) {
            	return ((Float) object).floatValue();
            }
            else if((clazz == String.class) || (clazz == BigDecimal.class)) {
            	try {
            		return Double.parseDouble(object.toString());
            	}
                catch(Exception e) {
                	log.debug("A value type does not match Double data type.");
                }
            }
    	}

    	return 0.0D;	
    }
    
    @SuppressWarnings("rawtypes")
    public float getFloat(String name) {
    	Object object = super.get(name);
      
    	if(object != null) {
    		Class clazz = object.getClass();
      
    		if(clazz == Float.class) {
    			return ((Float) object).floatValue();
    		}
    		else if((clazz == String.class) || (clazz == BigDecimal.class)) {
    			try {
    				return Float.parseFloat(object.toString());
    			}
    			catch(Exception e) {
    				log.debug("A value type does not match Float data type.");
    			}
    		}
    	}
    			
    	return 0.0F;
    }

	public byte[] getBinary(String name) {
		byte[] value = null;

		if(name != null && this.containsKey(name)) {
			value = (byte[]) (super.get(name));
		} 
		else {
			log.debug("A DataMap does not contain this key.");
		}

		return value;
	}
    
    @SuppressWarnings("rawtypes")
    public String toString() {
    	if(isEmpty()) {
    		return "Data does not exist.";
    	}
    	
		StringBuffer sb = new StringBuffer();
		Set keySet = super.keySet();
		Iterator iter = keySet.iterator();
		String key = null;
	    Object item = null;
		
		sb.append("\n\n----------------------------[DataMap Start]----------------------------\n\n");
	    
	    while(iter.hasNext()) {
	    	key = (String) iter.next();
	    	item = get(key);
	      
		    if(item == null) {
		    	sb.append(key + "=null\n");
		    }
		    else if(item instanceof String) {
		    	sb.append(key + "=[ " + item + " ]\n");
		    }
		    else if((item instanceof Integer) || (item instanceof Long) || (item instanceof Double) || (item instanceof Float) || (item instanceof Boolean)) {
		    	sb.append(key + "=[ " + item + " ]\n");
		    }
		    else if(item instanceof String[]) {
		    	String[] data = (String[]) item;
		    	sb.append(key + "=[ ");
	
		    	for(int j = 0; j < data.length; ++j) {
		    		sb.append(data[j] + ',');
		    	}
		    
		    	sb.append("] Array Size:" + data.length + " \n");
		    }
		    else {
		    	sb.append(key + "=[ " + item + " ] ClassName:" + item.getClass().getName() + "\n");
		    }
	    }
		    
	    sb.append("\n----------------------------[DataMap End]----------------------------");
	    
	    return sb.toString();
	}
}
