package com.rossgroupinc.memberz.bp.payment;

import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

/**
 *  For more information
 *  Refer : http://www.forte.net/devdocs/
 * */
public class AuthenticationHelper {

	/**
	 *  Secure Transaction key 
	 */
	private static final String SECURE_KEY= "f07dd47784a7a30e12ebb5c4c911370e";

	/**
	 * Api Access Id
	 */
	public static final String API_ACCESS_ID ="fc046aeabb44b3fc25e97cfed92a8ebd";
	
	/** Allowed hash method : md5, sha1, sha256 */
	public static final String HASH_METHOD = "HmacSHA256";
	
	/**
	 *  Version No
	 */
	public static final String VERSION_NO = "2.0";
	
	/**
	 * Payment Methods
	 */
	public static final String  METHOD_SALE = "sale";
	protected static final String METHOD_TOKEN="token";
	
	public static final String  METHOD_SCHEDULE = "schedule";
			
	
	/**
	 * 
	 * @param totalAmount Total Amount to be charge to user
	 * @param orderNumber Order No in your own system
	 * @param utcTime
	 * @return
	 * @throws InvalidKeyException
	 * @throws NoSuchAlgorithmException
	 */
	public String generateSignatureForSingleAmount(String method, String totalAmount, String orderNumber, String utcTime, String locationId) 
			throws InvalidKeyException, NoSuchAlgorithmException, UnsupportedEncodingException { 	
		//"api_access_id|method|version_number|total_amount|utc_time|order_number|customer_token|paymethod_token"
		//fc046aeabb44b3fc25e97cfed92a8ebd|sale|2.0|10.00|638768960167170000|1000||
		String value =	API_ACCESS_ID + "|" + method + "|" + VERSION_NO + "|" + totalAmount +"|" + utcTime + "|" + orderNumber +"||";
		System.out.println(value);
		String result = generateSignature(value);
		System.out.println(result);
		return result;
	}
	
	public String generateSignature(String value) throws NoSuchAlgorithmException, InvalidKeyException, UnsupportedEncodingException {
		   Mac sha256_HMAC = Mac.getInstance(HASH_METHOD);

	        SecretKeySpec secret_key = new SecretKeySpec(SECURE_KEY.getBytes("UTF-8"), HASH_METHOD);
	        sha256_HMAC.init(secret_key);

	        return byteArrayToHex(sha256_HMAC.doFinal(value.getBytes("UTF-8")));
	}	
	
	   public static String byteArrayToHex(byte[] a) {
	        StringBuilder sb = new StringBuilder(a.length * 2);
	        for(byte b: a)
	            sb.append(String.format("%02x", b));
	        return sb.toString();
	    }
}
