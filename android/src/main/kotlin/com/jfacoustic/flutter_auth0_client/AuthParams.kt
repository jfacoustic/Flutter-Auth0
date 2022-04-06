package com.jfacoustic.flutter_auth0_client

class AuthParams(
    val clientId: String,
    val domain: String,
    val scope: String? = null,
    val audience: String? = null,
    val useEmphemeral: Boolean = false
)
