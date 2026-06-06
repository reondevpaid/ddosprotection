cat > /tmp/ultimate-guardian.sh << 'ULTIMATE_EOF'
#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║     ULTIMATE GUARDIAN - Complete Layer 7 DDoS Protection System             ║
# ║     Anti-DDoS | Anti-Slowloris | Anti-Botnet | CAPTCHA | IP Tunneling       ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

clear
cat << "BANNER"
 ██╗   ██╗██╗  ████████╗██╗███╗   ███╗ █████╗ ████████╗███████╗
 ██║   ██║██║  ╚══██╔══╝██║████╗ ████║██╔══██╗╚══██╔══╝██╔════╝
 ██║   ██║██║     ██║   ██║██╔████╔██║███████║   ██║   █████╗  
 ██║   ██║██║     ██║   ██║██║╚██╔╝██║██╔══██║   ██║   ██╔══╝  
 ╚██████╔╝███████╗██║   ██║██║ ╚═╝ ██║██║  ██║   ██║   ███████╗
  ╚═════╝ ╚══════╝╚═╝   ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝
                                                                 
 ██████╗ ██╗   ██╗ █████╗ ██████╗ ██████╗ ██╗ █████╗ ███╗   ██╗
██╔════╝ ██║   ██║██╔══██╗██╔══██╗██╔══██╗██║██╔══██╗████╗  ██║
██║  ███╗██║   ██║███████║██████╔╝██║  ██║██║███████║██╔██╗ ██║
██║   ██║██║   ██║██╔══██║██╔══██╗██║  ██║██║██╔══██║██║╚██╗██║
╚██████╔╝╚██████╔╝██║  ██║██║  ██║██████╔╝██║██║  ██║██║ ╚████║
 ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
BANNER

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# Configuration
INSTALL_DIR="/etc/ultimate-guardian"
LOG_DIR="/var/log/ultimate-guardian"
CACHE_DIR="/var/cache/ultimate-guardian"
TUNNEL_DIR="/etc/ultimate-guardian/tunnels"
CAPTCHA_DIR="/etc/ultimate-guardian/captcha"
BAN_DIR="/etc/ultimate-guardian/bans"

echo -e "${BLUE}[*] Checking root privileges...${NC}"
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}[!] Please run as root${NC}"
    exit 1
fi

# Create directory structure
echo -e "${BLUE}[*] Creating directory structure...${NC}"
mkdir -p $INSTALL_DIR/{scripts,ssl,tunnels,config,backup,captcha,bans}
mkdir -p $LOG_DIR/{attacks,bans,afk,traffic,tunnels,captcha,slowloris,botnet}
mkdir -p $CACHE_DIR/{sessions,captcha,templates,packets}
mkdir -p $CAPTCHA_DIR/{challenges,verified,tokens}
mkdir -p $BAN_DIR/{temporary,permanent,network}
mkdir -p /var/run/ultimate-guardian

# Install ALL dependencies
echo -e "${BLUE}[*] Installing comprehensive dependencies...${NC}"
apt-get update -y
apt-get install -y \
    iptables ipset fail2ban net-tools tcpdump curl jq build-essential \
    libpcap-dev tcptrace iftop nethogs nodejs npm wireguard-tools \
    openvpn stunnel4 haproxy nginx certbot python3-pip ufw \
    libnginx-mod-http-lua lua-cjson lua-resty-redis lua-resty-http \
    redis-server python3-dev python3-setuptools python3-pil \
    python3-numpy python3-opencv libffi-dev libssl-dev \
    git unzip wget perl make cmake autoconf automake \
    libtool libxml2-dev libxslt1-dev zlib1g-dev \
    libgeoip-dev libmaxminddb-dev mmdb-bin geoipupdate \
    libluajit-5.1-dev luajit libpcre3 libpcre3-dev \
    libssl-dev libcurl4-openssl-dev libjansson-dev \
    libyaml-dev libsodium-dev libsodium23

# Install Node.js packages for advanced protection
npm install -g pm2 express helmet express-rate-limit express-slow-down \
    hpp cors cookie-parser express-session rate-limiter-flexible \
    express-useragent geoip-lite csurf svg-captcha sharp \
    crypto-js bcryptjs jsonwebtoken socket.io redis ioredis \
    dotenv winston morgan compression helmet-csp

echo -e "${GREEN}[✓] Dependencies installed${NC}"

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║     COMPLETE LAYER 7 DDoS PROTECTION ENGINE                                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

cat > $INSTALL_DIR/scripts/layer7-protection.js << 'LAYER7_EOF'
// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║                    ULTIMATE LAYER 7 DDoS PROTECTION ENGINE                   ║
// ╚══════════════════════════════════════════════════════════════════════════════╝

const express = require('express');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const slowDown = require('express-slow-down');
const hpp = require('hpp');
const cors = require('cors');
const cookieParser = require('cookie-parser');
const session = require('express-session');
const { RateLimiterMemory, RateLimiterRedis } = require('rate-limiter-flexible');
const useragent = require('express-useragent');
const geoip = require('geoip-lite');
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');
const svgCaptcha = require('svg-captcha');
const Redis = require('ioredis');
const cluster = require('cluster');
const os = require('os');
const WebSocket = require('ws');
const http = require('http');
const https = require('https');
const net = require('net');
const compression = require('compression');
const morgan = require('morgan');
const winston = require('winston');
const sharp = require('sharp');

// Initialize Redis for distributed rate limiting
const redis = new Redis({
    host: process.env.REDIS_HOST || '127.0.0.1',
    port: process.env.REDIS_PORT || 6379,
    password: process.env.REDIS_PASSWORD || '',
    db: 0,
    retryStrategy: (times) => Math.min(times * 50, 2000)
});

// Logger configuration
const logger = winston.createLogger({
    level: 'info',
    format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json()
    ),
    transports: [
        new winston.transports.File({ filename: '/var/log/ultimate-guardian/error.log', level: 'error' }),
        new winston.transports.File({ filename: '/var/log/ultimate-guardian/combined.log' }),
        new winston.transports.Console({ format: winston.format.simple() })
    ]
});

// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║                    ATTACK PATTERN DATABASE                                   ║
// ╚══════════════════════════════════════════════════════════════════════════════╝

const attackPatterns = {
    sql_injection: /(\b(SELECT|INSERT|UPDATE|DELETE|DROP|UNION|ALTER|CREATE|EXEC|DECLARE|TRUNCATE)\b)|(--[^\n]*$)|(\bOR\b.*=.*--)/i,
    xss: /(<script[\s\S]*?>[\s\S]*?<\/script>)|(<[^>]*on\w+\s*=\s*["'][^"']*["'][^>]*>)|(javascript\s*:)/i,
    path_traversal: /\.\.\/|\.\.\\|%2e%2e%2f|%2e%2e%5c|%2e%2e\//i,
    command_injection: /[;&|`]|\b(wget|curl|bash|sh|nc|telnet|python|perl|ruby|php)\b/i,
    file_inclusion: /(\.\.\/|php:\/\/|file:\/\/|expect:\/\/|phar:\/\/|zip:\/\/)/i,
    ssrf: /(http:\/\/169\.254\.169\.254|http:\/\/metadata\.google\.internal)/i,
    scanner_patterns: /(nikto|nmap|nessus|burp|wpscan|sqlmap|hydra|medusa)/i,
    bot_patterns: /(bot|crawler|spider|scraper|curl|wget|python-requests|go-http-client|java|libwww)/i,
    slowloris_patterns: /(keep-alive|X-a: b|X-a:\s+b|Content-Length:\s+0)/i
};

// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║                    ADVANCED CAPTCHA SYSTEM                                   ║
// ╚══════════════════════════════════════════════════════════════════════════════╝

class AdvancedCaptchaSystem {
    constructor() {
        this.activeChallenges = new Map();
        this.verifiedTokens = new Map();
        this.failedAttempts = new Map();
        this.maxAttempts = 3;
        this.tokenExpiry = 3600000; // 1 hour
        this.cleanupInterval = setInterval(() => this.cleanup(), 300000); // Every 5 minutes
    }

    generateCaptcha(ip, userAgent) {
        // Create math captcha for better security
        const num1 = Math.floor(Math.random() * 50) + 1;
        const num2 = Math.floor(Math.random() * 50) + 1;
        const operators = ['+', '-', '*'];
        const operator = operators[Math.floor(Math.random() * operators.length)];
        let answer;
        
        switch(operator) {
            case '+': answer = num1 + num2; break;
            case '-': answer = num1 - num2; break;
            case '*': answer = num1 * num2; break;
        }

        const challengeId = crypto.randomBytes(32).toString('hex');
        const question = `${num1} ${operator} ${num2} = ?`;
        
        // Generate SVG captcha
        const captcha = svgCaptcha.create({
            size: 6,
            noise: 4,
            color: true,
            background: '#f0f0f0',
            width: 300,
            height: 100,
            fontSize: 60,
            charPreset: 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789'
        });

        const challenge = {
            id: challengeId,
            mathQuestion: question,
            mathAnswer: answer.toString(),
            textCaptcha: captcha.text,
            svgCaptcha: captcha.data,
            ip: ip,
            userAgent: userAgent,
            timestamp: Date.now(),
            attempts: 0,
            type: 'dual' // Both math and visual captcha
        };

        // Store challenge
        this.activeChallenges.set(challengeId, challenge);
        
        // Store in Redis for persistence
        redis.setex(`captcha:${challengeId}`, 300, JSON.stringify({
            mathAnswer: challenge.mathAnswer,
            textCaptcha: challenge.textCaptcha,
            timestamp: challenge.timestamp
        }));

        return {
            challengeId: challengeId,
            mathQuestion: question,
            svgCaptcha: captcha.data,
            message: 'Solve both challenges to verify you are human'
        };
    }

    verifyCaptcha(challengeId, mathAnswer, textAnswer, ip) {
        const challenge = this.activeChallenges.get(challengeId);
        
        if (!challenge) {
            return { success: false, error: 'Challenge expired or not found' };
        }

        // Check attempts
        const failKey = `${ip}:${challengeId}`;
        const attempts = this.failedAttempts.get(failKey) || 0;
        
        if (attempts >= this.maxAttempts) {
            return { success: false, error: 'Too many failed attempts. Try again later.' };
        }

        // Verify both answers
        const mathCorrect = mathAnswer === challenge.mathAnswer;
        const textCorrect = textAnswer.toLowerCase() === challenge.textCaptcha.toLowerCase();
        const timeValid = (Date.now() - challenge.timestamp) < 300000; // 5 minutes

        if (mathCorrect && textCorrect && timeValid) {
            // Generate verification token
            const token = crypto.randomBytes(64).toString('hex');
            const tokenData = {
                ip: ip,
                verified: true,
                timestamp: Date.now(),
                userAgent: challenge.userAgent
            };

            // Store token
            this.verifiedTokens.set(token, tokenData);
            redis.setex(`verified:${token}`, this.tokenExpiry, JSON.stringify(tokenData));

            // Clean up challenge
            this.activeChallenges.delete(challengeId);
            this.failedAttempts.delete(failKey);

            return { 
                success: true, 
                token: token,
                message: 'Verification successful'
            };
        } else {
            // Increment failed attempts
            this.failedAttempts.set(failKey, attempts + 1);
            setTimeout(() => this.failedAttempts.delete(failKey), 900000); // Clear after 15 minutes

            return { 
                success: false, 
                error: 'Incorrect answer',
                attemptsLeft: this.maxAttempts - (attempts + 1)
            };
        }
    }

    isVerified(token, ip) {
        if (!token) return false;
        
        const tokenData = this.verifiedTokens.get(token);
        if (!tokenData) return false;
        
        // Verify token ownership
        if (tokenData.ip !== ip) return false;
        if (Date.now() - tokenData.timestamp > this.tokenExpiry) {
            this.verifiedTokens.delete(token);
            return false;
        }
        
        return true;
    }

    cleanup() {
        const now = Date.now();
        
        // Clean expired challenges
        for (const [id, challenge] of this.activeChallenges) {
            if (now - challenge.timestamp > 300000) {
                this.activeChallenges.delete(id);
                redis.del(`captcha:${id}`);
            }
        }
        
        // Clean expired tokens
        for (const [token, data] of this.verifiedTokens) {
            if (now - data.timestamp > this.tokenExpiry) {
                this.verifiedTokens.delete(token);
                redis.del(`verified:${token}`);
            }
        }
        
        // Clean failed attempts
        for (const [key, attempts] of this.failedAttempts) {
            if (attempts > this.maxAttempts * 3) {
                this.failedAttempts.delete(key);
            }
        }
    }
}

// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║                    ANTI-SLOWLORIS PROTECTION                                 ║
// ╚══════════════════════════════════════════════════════════════════════════════╝

class AntiSlowlorisProtection {
    constructor() {
        this.connections = new Map();
        this.suspiciousIPs = new Map();
        this.config = {
            maxConnectionsPerIP: 20,
            maxHeaderTimeout: 5000, // 5 seconds
            maxBodyTimeout: 10000,  // 10 seconds
            minTransferRate: 100,   // bytes per second
            maxIncompleteHeaders: 10,
            connectionCheckInterval: 1000 // 1 second
        };
        
        this.startMonitor();
    }

    trackConnection(ip, socket) {
        if (!this.connections.has(ip)) {
            this.connections.set(ip, []);
        }
        
        const connection = {
            socket: socket,
            startTime: Date.now(),
            bytesReceived: 0,
            lastActivity: Date.now(),
            headersComplete: false,
            requestComplete: false
        };
        
        this.connections.get(ip).push(connection);
        
        // Monitor socket events
        socket.on('data', (data) => {
            connection.bytesReceived += data.length;
            connection.lastActivity = Date.now();
        });
        
        socket.on('end', () => {
            this.removeConnection(ip, connection);
        });
        
        socket.on('error', () => {
            this.removeConnection(ip, connection);
        });
        
        return connection;
    }

    removeConnection(ip, connection) {
        const ipConns = this.connections.get(ip);
        if (ipConns) {
            const index = ipConns.indexOf(connection);
            if (index > -1) {
                ipConns.splice(index, 1);
            }
            if (ipConns.length === 0) {
                this.connections.delete(ip);
            }
        }
    }

    detectSlowloris(ip) {
        const ipConns = this.connections.get(ip);
        if (!ipConns) return false;
        
        const now = Date.now();
        let slowConnections = 0;
        
        for (const conn of ipConns) {
            const connectionAge = now - conn.startTime;
            const idleTime = now - conn.lastActivity;
            
            // Check for slow connection patterns
            if (connectionAge > this.config.maxHeaderTimeout && !conn.headersComplete) {
                slowConnections++;
            } else if (idleTime > this.config.maxHeaderTimeout) {
                slowConnections++;
            } else if (conn.bytesReceived < this.config.minTransferRate && connectionAge > 10000) {
                slowConnections++;
            }
        }
        
        // Mark as suspicious if many slow connections
        if (slowConnections >= this.config.maxIncompleteHeaders) {
            this.suspiciousIPs.set(ip, {
                count: (this.suspiciousIPs.get(ip)?.count || 0) + 1,
                timestamp: now
            });
            
            // Block if repeatedly suspicious
            if (this.suspiciousIPs.get(ip).count > 3) {
                this.blockIP(ip);
                return true;
            }
        }
        
        return slowConnections > ipConns.length * 0.8; // 80% of connections are slow
    }

    blockIP(ip) {
        // Add to iptables
        const { execSync } = require('child_process');
        execSync(`iptables -I INPUT -s ${ip} -j DROP`);
        execSync(`echo "${ip} # Slowloris attack blocked at $(date)" >> /etc/ultimate-guardian/bans/slowloris-bans.txt`);
        
        // Add to Redis for distributed blocking
        redis.setex(`blocked:${ip}`, 7200, 'slowloris'); // 2 hours
        
        logger.warn(`Blocked Slowloris attack from ${ip}`);
    }

    startMonitor() {
        setInterval(() => {
            const now = Date.now();
            
            for (const [ip, conns] of this.connections) {
                // Clean up dead connections
                const activeConns = conns.filter(conn => {
                    return now - conn.lastActivity < this.config.maxBodyTimeout;
                });
                
                if (activeConns.length !== conns.length) {
                    this.connections.set(ip, activeConns);
                }
                
                // Check connection limits
                if (activeConns.length > this.config.maxConnectionsPerIP * 2) {
                    this.blockIP(ip);
                }
                
                // Detect slowloris
                this.detectSlowloris(ip);
            }
            
            // Clean up old entries
            for (const [ip, data] of this.suspiciousIPs) {
                if (now - data.timestamp > 3600000) { // 1 hour
                    this.suspiciousIPs.delete(ip);
                }
            }
        }, this.config.connectionCheckInterval);
    }
}

// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║                    ANTI-BOTNET PROTECTION                                    ║
// ╚══════════════════════════════════════════════════════════════════════════════╝

class AntiBotnetProtection {
    constructor() {
        this.botScores = new Map();
        this.blockedBots = new Set();
        this.signatures = new Map();
        this.behavioralProfiles = new Map();
        
        this.loadBotSignatures();
        this.startBehavioralAnalysis();
    }

    loadBotSignatures() {
        // Known bot signatures
        this.signatures.set('ahrefsbot', { score: 2, category: 'seo' });
        this.signatures.set('semrushbot', { score: 2, category: 'seo' });
        this.signatures.set('googlebot', { score: -5, category: 'search' }); // Whitelist
        this.signatures.set('bingbot', { score: -5, category: 'search' }); // Whitelist
        this.signatures.set('slurp', { score: 2, category: 'seo' });
        this.signatures.set('duckduckbot', { score: -3, category: 'search' });
        this.signatures.set('baiduspider', { score: 1, category: 'search' });
        this.signatures.set('yandexbot', { score: 1, category: 'search' });
        this.signatures.set('facebookexternalhit', { score: 3, category: 'social' });
        this.signatures.set('twitterbot', { score: 3, category: 'social' });
        this.signatures.set('rogerbot', { score: 2, category: 'seo' });
        this.signatures.set('exabot', { score: 2, category: 'seo' });
        this.signatures.set('mj12bot', { score: 2, category: 'seo' });
        this.signatures.set('dotbot', { score: 2, category: 'seo' });
        this.signatures.set('gigabot', { score: 2, category: 'seo' });
        this.signatures.set('aspseekbot', { score: 2, category: 'seo' });
        
        // Malicious bot patterns
        this.maliciousPatterns = [
            /sqlmap/i,
            /nikto/i,
            /nmap/i,
            /nessus/i,
            /burpsuite/i,
            /wpscan/i,
            /hydra/i,
            /medusa/i,
            /metasploit/i,
            /acunetix/i,
            /appscan/i,
            /grendel/i,
            /havij/i,
            /netsparker/i,
            /openvas/i,
            /paros/i,
            /qualys/i,
            /webinspect/i,
            /zmeu/i,
            /armitage/i,
            /beef/i,
            /cobaltstrike/i
        ];
    }

    analyzeRequest(ip, userAgent, headers, requestPath) {
        let score = 0;
        const reasons = [];

        // Check user agent
        if (!userAgent || userAgent.length < 10) {
            score += 10;
            reasons.push('Missing or short user agent');
        }

        // Check for bot signatures
        for (const [botName, botData] of this.signatures) {
            if (userAgent && userAgent.toLowerCase().includes(botName)) {
                score += botData.score;
                reasons.push(`Bot signature: ${botName}`);
            }
        }

        // Check for malicious patterns
        for (const pattern of this.maliciousPatterns) {
            if (userAgent && pattern.test(userAgent)) {
                score += 50;
                reasons.push('Malicious bot detected');
                break;
            }
        }

        // Check headers
        const requiredHeaders = ['accept', 'accept-language', 'accept-encoding'];
        for (const header of requiredHeaders) {
            if (!headers[header]) {
                score += 5;
                reasons.push(`Missing header: ${header}`);
            }
        }

        // Check for automated tool patterns
        if (headers['x-forwarded-for'] && headers['x-forwarded-for'].includes(ip)) {
            score += 5;
            reasons.push('Suspicious X-Forwarded-For header');
        }

        // Rate-based bot detection
        const currentScore = this.botScores.get(ip) || 0;
        this.botScores.set(ip, currentScore + score);

        // Check behavioral patterns
        const behavior = this.behavioralProfiles.get(ip) || {
            requests: [],
            uniquePaths: new Set(),
            requestTimes: []
        };

        behavior.requests.push({
            path: requestPath,
            time: Date.now(),
            userAgent: userAgent
        });
        behavior.uniquePaths.add(requestPath);
        behavior.requestTimes.push(Date.now());

        // Detect rapid requests
        const recentRequests = behavior.requestTimes.filter(time => 
            Date.now() - time < 10000 // Last 10 seconds
        );

        if (recentRequests.length > 50) {
            score += 30;
            reasons.push('Rapid request rate');
        }

        // Detect path scanning
        if (behavior.uniquePaths.size > 100 && behavior.requests.length < 1000) {
            score += 20;
            reasons.push('Path scanning detected');
        }

        this.behavioralProfiles.set(ip, behavior);

        // Block if score too high
        if (this.botScores.get(ip) > 100) {
            this.blockBot(ip, reasons);
            return { blocked: true, score: this.botScores.get(ip), reasons };
        }

        return { blocked: false, score: this.botScores.get(ip), reasons };
    }

    blockBot(ip, reasons) {
        if (!this.blockedBots.has(ip)) {
            this.blockedBots.add(ip);
            
            // Add to Redis
            redis.setex(`botnet_blocked:${ip}`, 86400, JSON.stringify({
                timestamp: Date.now(),
                reasons: reasons
            }));

            // Add to iptables
            const { execSync } = require('child_process');
            execSync(`iptables -I INPUT -s ${ip} -j DROP`);
            execSync(`echo "${ip} # Botnet blocked at $(date) - ${reasons.join(', ')}" >> /etc/ultimate-guardian/bans/botnet-bans.txt`);

            logger.warn(`Blocked botnet IP ${ip}: ${reasons.join(', ')}`);
        }
    }

    startBehavioralAnalysis() {
        setInterval(() => {
            const now = Date.now();
            
            for (const [ip, behavior] of this.behavioralProfiles) {
                // Clean old entries
                behavior.requests = behavior.requests.filter(req => 
                    now - req.time < 3600000 // 1 hour
                );
                behavior.requestTimes = behavior.requestTimes.filter(time =>
                    now - time < 3600000
                );

                if (behavior.requests.length === 0) {
                    this.behavioralProfiles.delete(ip);
                }
            }

            // Decay bot scores
            for (const [ip, score] of this.botScores) {
                if (score > 0) {
                    this.botScores.set(ip, Math.max(0, score - 1));
                }
            }
        }, 60000); // Every minute
    }
}

// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║                    MAIN PROTECTION MIDDLEWARE                                ║
// ╚══════════════════════════════════════════════════════════════════════════════╝

class UltimateProtection {
    constructor() {
        this.captcha = new AdvancedCaptchaSystem();
        this.antiSlowloris = new AntiSlowlorisProtection();
        this.antiBotnet = new AntiBotnetProtection();
        this.requestCounts = new Map();
        this.blockedIPs = new Set();
    }

    middleware() {
        return async (req, res, next) => {
            const ip = req.ip || req.connection.remoteAddress;
            const userAgent = req.headers['user-agent'] || 'unknown';
            const requestPath = req.path;

            try {
                // 1. Check if IP is blocked
                if (this.blockedIPs.has(ip)) {
                    return res.status(403).json({ error: 'Access denied' });
                }

                // Check Redis for blocked IPs
                const isBlocked = await redis.get(`blocked:${ip}`);
                if (isBlocked) {
                    this.blockedIPs.add(ip);
                    return res.status(403).json({ error: 'Access denied' });
                }

                // 2. Anti-Botnet check
                const botCheck = this.antiBotnet.analyzeRequest(ip, userAgent, req.headers, requestPath);
                if (botCheck.blocked) {
                    return res.status(403).json({ 
                        error: 'Access denied',
                        reason: 'Bot detection',
                        score: botCheck.score
                    });
                }

                // 3. Attack pattern detection
                for (const [patternName, pattern] of Object.entries(attackPatterns)) {
                    if (pattern.test(requestPath) || pattern.test(req.headers['user-agent'] || '')) {
                        logger.warn(`Attack pattern detected: ${patternName} from ${ip}`);
                        await this.blockIP(ip, `Attack pattern: ${patternName}`);
                        return res.status(403).json({ error: 'Malicious request detected' });
                    }
                }

                // 4. CAPTCHA requirement for suspicious IPs
                const botScore = this.antiBotnet.botScores.get(ip) || 0;
                if (botScore > 50 && !this.captcha.isVerified(req.headers['x-captcha-token'], ip)) {
                    const captcha = this.captcha.generateCaptcha(ip, userAgent);
                    return res.status(428).json({
                        error: 'CAPTCHA required',
                        captcha: captcha
                    });
                }

                // 5. Track connection for Slowloris
                this.antiSlowloris.trackConnection(ip, req.socket);

                // 6. Request counting
                const count = (this.requestCounts.get(ip) || 0) + 1;
                this.requestCounts.set(ip, count);

                if (count > 10000) {
                    await this.blockIP(ip, 'Request limit exceeded');
                    return res.status(429).json({ error: 'Too many requests' });
                }

                next();
            } catch (error) {
                logger.error('Protection middleware error:', error);
                next();
            }
        };
    }

    async blockIP(ip, reason) {
        this.blockedIPs.add(ip);
        await redis.setex(`blocked:${ip}`, 3600, reason);
        
        const { execSync } = require('child_process');
        execSync(`iptables -I INPUT -s ${ip} -j DROP`);
        
        logger.warn(`Blocked IP ${ip}: ${reason}`);
    }
}

// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║                    EXPRESS APPLICATION SETUP                                 ║
// ╚══════════════════════════════════════════════════════════════════════════════╝

if (cluster.isMaster) {
    const numCPUs = os.cpus().length;
    console.log(`Master ${process.pid} is running`);
    
    for (let i = 0; i < numCPUs; i++) {
        cluster.fork();
    }
    
    cluster.on('exit', (worker, code, signal) => {
        console.log(`Worker ${worker.process.pid} died`);
        cluster.fork();
    });
} else {
    const app = express();
    const protection = new UltimateProtection();

    // Trust proxy
    app.set('trust proxy', 1);

    // Compression
    app.use(compression());

    // Security headers with comprehensive CSP
    app.use(helmet({
        contentSecurityPolicy: {
            directives: {
                defaultSrc: ["'self'"],
                scriptSrc: ["'self'", "'unsafe-inline'", "'unsafe-eval'"],
                styleSrc: ["'self'", "'unsafe-inline'"],
                imgSrc: ["'self'", "data:", "https:", "blob:"],
                fontSrc: ["'self'", "https:", "data:"],
                objectSrc: ["'none'"],
                mediaSrc: ["'self'"],
                frameSrc: ["'none'"],
                connectSrc: ["'self'", "wss:", "https:"]
            }
        },
        crossOriginEmbedderPolicy: true,
        crossOriginOpenerPolicy: { policy: "same-origin" },
        crossOriginResourcePolicy: { policy: "same-origin" },
        dnsPrefetchControl: { allow: false },
        frameguard: { action: "deny" },
        hidePoweredBy: true,
        hsts: {
            maxAge: 31536000,
            includeSubDomains: true,
            preload: true
        },
        ieNoOpen: true,
        noSniff: true,
        referrerPolicy: { policy: "strict-origin-when-cross-origin" },
        xssFilter: true
    }));

    // CORS
    app.use(cors({
        origin: process.env.ALLOWED_ORIGINS || '*',
        methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
        allowedHeaders: ['Content-Type', 'Authorization', 'X-Captcha-Token', 'X-CSRF-Token'],
        credentials: true,
        maxAge: 600
    }));

    // Body parsing with limits
    app.use(express.json({ limit: '10kb' }));
    app.use(express.urlencoded({ extended: true, limit: '10kb' }));
    app.use(cookieParser());
    
    // Session management
    app.use(session({
        secret: process.env.SESSION_SECRET || crypto.randomBytes(64).toString('hex'),
        resave: false,
        saveUninitialized: false,
        cookie: {
            secure: true,
            httpOnly: true,
            sameSite: 'strict',
            maxAge: 3600000
        }
    }));

    // User agent parsing
    app.use(useragent.express());

    // HPP protection
    app.use(hpp());

    // Rate limiting
    const globalLimiter = rateLimit({
        windowMs: 60000,
        max: 100,
        message: 'Too many requests',
        standardHeaders: true,
        legacyHeaders: false
    });

    const strictLimiter = rateLimit({
        windowMs: 60000,
        max: 10,
        message: 'Too many requests',
        standardHeaders: true,
        legacyHeaders: false
    });

    // Speed limiter
    const speedLimiter = slowDown({
        windowMs: 900000,
        delayAfter: 50,
        delayMs: 500
    });

    // Apply protection middleware
    app.use(protection.middleware());

    // CAPTCHA endpoints
    app.get('/captcha/challenge', (req, res) => {
        const captcha = protection.captcha.generateCaptcha(
            req.ip,
            req.headers['user-agent']
        );
        res.json(captcha);
    });

    app.post('/captcha/verify', async (req, res) => {
        const { challengeId, mathAnswer, textAnswer } = req.body;
        const result = protection.captcha.verifyCaptcha(
            challengeId,
            mathAnswer,
            textAnswer,
            req.ip
        );
        
        if (result.success) {
            res.cookie('captcha_token', result.token, {
                httpOnly: true,
                secure: true,
                sameSite: 'strict',
                maxAge: 3600000
            });
        }
        
        res.json(result);
    });

    // Protected routes with various rate limits
    app.use('/api/', globalLimiter);
    app.use('/api/auth/', strictLimiter);
    app.use('/admin/', strictLimiter);
    app.use('/panel/', strictLimiter);

    // Main panel route
    app.get('/', speedLimiter, (req, res) => {
        res.sendFile(path.join(__dirname, 'public', 'index.html'));
    });

    // API routes
    app.get('/api/status', (req, res) => {
        res.json({
            status: 'protected',
            timestamp: Date.now(),
            protection: 'active',
            layers: 7
        });
    });

    // Error handling
    app.use((err, req, res, next) => {
        logger.error('Application error:', err);
        res.status(500).json({ error: 'Internal server error' });
    });

    // 404 handler
    app.use((req, res) => {
        res.status(404).json({ error: 'Not found' });
    });

    const PORT = process.env.PORT || 3000;
    app.listen(PORT, () => {
        console.log(`Worker ${process.pid} started on port ${PORT}`);
        console.log('Ultimate Layer 7 DDoS Protection active');
        console.log('- Anti-Slowloris: Active');
        console.log('- Anti-Botnet: Active');
        console.log('- CAPTCHA: Active');
        console.log('- Rate Limiting: Active');
        console.log('- Attack Pattern Detection: Active');
    });
}

module.exports = { UltimateProtection, AdvancedCaptchaSystem, AntiSlowlorisProtection, AntiBotnetProtection };
LAYER7_EOF

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║     NGINX CONFIGURATION WITH LAYER 7 PROTECTION                             ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

cat > /etc/nginx/conf.d/ultimate-protection.conf << 'NGINX_EOF'
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║              ULTIMATE NGINX LAYER 7 PROTECTION CONFIGURATION                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Rate limiting zones
limit_req_zone $binary_remote_addr zone=general:100m rate=30r/s;
limit_req_zone $binary_remote_addr zone=login:50m rate=5r/m;
limit_req_zone $binary_remote_addr zone=api:50m rate=10r/s;
limit_req_zone $binary_remote_addr zone=strict:100m rate=1r/s;
limit_conn_zone $binary_remote_addr zone=connperip:50m;
limit_conn_zone $server_name zone=perserver:50m;

# Map for bot blocking
map $http_user_agent $bot_blocked {
    default 0;
    ~*(ahrefsbot|semrushbot|rogerbot|exabot|mj12bot|dotbot|gigabot|aspseekbot) 1;
    ~*(sqlmap|nikto|nmap|nessus|burp|wpscan|hydra|medusa|metasploit) 1;
    ~*(acunetix|appscan|grendel|havij|netsparker|openvas|paros|qualys) 1;
    ~*(webinspect|zmeu|armitage|beef|cobaltstrike) 1;
}

# Map for country blocking (optional)
geo $blocked_country {
    default 0;
    # Add country codes to block
    # CN 1; # China
    # RU 1; # Russia
    # KP 1; # North Korea
    # IR 1; # Iran
}

server {
    listen 80;
    listen 443 ssl http2;
    server_name _;

    # SSL configuration
    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:50m;
    ssl_session_timeout 1d;
    ssl_session_tickets off;
    ssl_stapling on;
    ssl_stapling_verify on;

    # Security headers
    add_header X-Frame-Options "DENY" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Permissions-Policy "camera=(), microphone=(), geolocation=(), interest-cohort=()" always;
    add_header Cross-Origin-Embedder-Policy "require-corp" always;
    add_header Cross-Origin-Opener-Policy "same-origin" always;
    add_header Cross-Origin-Resource-Policy "same-origin" always;

    # Connection limits
    limit_conn connperip 20;
    limit_conn perserver 1000;

    # Request size limits
    client_max_body_size 10m;
    client_body_buffer_size 128k;
    client_header_buffer_size 1k;
    large_client_header_buffers 4 8k;

    # Timeout settings (Anti-Slowloris)
    client_body_timeout 10s;
    client_header_timeout 5s;
    send_timeout 10s;
    keepalive_timeout 5s;
    keepalive_requests 100;

    # Block bots
    if ($bot_blocked) {
        return 403;
    }

    # Block countries (optional)
    if ($blocked_country) {
        return 403;
    }

    # Block common attack patterns
    location ~* \.(sql|log|conf|bak|backup|old|swp|swo|dist|ini|env)$ {
        deny all;
        return 403;
    }

    location ~ /\. {
        deny all;
        return 403;
    }

    location ~* (wp-config\.php|xmlrpc\.php|wp-login\.php) {
        deny all;
        return 403;
    }

    # CAPTCHA endpoint
    location /captcha/ {
        proxy_pass http://localhost:3000;
        limit_req zone=strict burst=5 nodelay;
        
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Login protection
    location /login {
        limit_req zone=login burst=3 nodelay;
        limit_conn connperip 5;
        
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Admin area protection
    location /admin {
        limit_req zone=strict burst=3 nodelay;
        limit_conn connperip 3;
        
        # Require CAPTCHA verification
        auth_request /captcha/verify;
        
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # API protection
    location /api/ {
        limit_req zone=api burst=20 nodelay;
        limit_conn connperip 10;
        
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # API specific headers
        add_header Cache-Control "no-store, no-cache, must-revalidate" always;
    }

    # Main application
    location / {
        limit_req zone=general burst=30 nodelay;
        limit_conn connperip 15;
        
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Port $server_port;
        
        # Proxy buffer settings
        proxy_buffering on;
        proxy_buffer_size 4k;
        proxy_buffers 8 4k;
        proxy_busy_buffers_size 8k;
        proxy_max_temp_file_size 1024m;
        
        # Proxy timeout settings
        proxy_connect_timeout 5s;
        proxy_send_timeout 10s;
        proxy_read_timeout 10s;
    }

    # Health check (no rate limiting)
    location /health {
        limit_req off;
        limit_conn off;
        
        access_log off;
        return 200 "OK";
    }

    # Block access to sensitive files
    location ~* \.(git|svn|hg|bzr)$ {
        deny all;
        return 403;
    }

    # Deny access to backup files
    location ~* \.(tar|gz|zip|rar|7z)$ {
        deny all;
        return 403;
    }
}
NGINX_EOF

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║     FAIL2BAN COMPREHENSIVE CONFIGURATION                                    ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

cat > /etc/fail2ban/jail.d/ultimate-guardian.conf << 'FAIL2BAN_EOF'
[ultimate-ssh]
enabled = true
port = ssh
filter = ultimate-guardian
logpath = /var/log/auth.log
maxretry = 5
bantime = 1200
findtime = 300
action = iptables-multiport[name=SSH, port="ssh", protocol=tcp]
         iptables-multiport[name=SSH-UDP, port="ssh", protocol=udp]

[ultimate-web]
enabled = true
port = http,https,8080,8443
filter = ultimate-guardian
logpath = /var/log/nginx/access.log
         /var/log/nginx/error.log
maxretry = 5
bantime = 1200
findtime = 300
action = iptables-multiport[name=WEB, port="http,https,8080,8443", protocol=tcp]

[ultimate-panel]
enabled = true
port = http,https
filter = ultimate-guardian
logpath = /var/log/ultimate-guardian/access.log
maxretry = 5
bantime = 1200
findtime = 300
action = iptables-multiport[name=PANEL, port="http,https", protocol=tcp]

[ultimate-slowloris]
enabled = true
port = http,https
filter = ultimate-slowloris
logpath = /var/log/ultimate-guardian/slowloris/detections.log
maxretry = 1
bantime = 7200
findtime = 60
action = iptables-multiport[name=SLOWLORIS, port="http,https", protocol=tcp]

[ultimate-botnet]
enabled = true
port = http,https
filter = ultimate-botnet
logpath = /var/log/ultimate-guardian/botnet/detections.log
maxretry = 1
bantime = 86400
findtime = 300
action = iptables-multiport[name=BOTNET, port="http,https", protocol=tcp]

[ultimate-ddos]
enabled = true
port = all
filter = ultimate-ddos
logpath = /var/log/ultimate-guardian/attacks/detected-attacks.log
maxretry = 1
bantime = 3600
findtime = 60
action = iptables-allports[name=DDOS, protocol=tcp]
         iptables-allports[name=DDOS-UDP, protocol=udp]
FAIL2BAN_EOF

# Create comprehensive filter
cat > /etc/fail2ban/filter.d/ultimate-guardian.conf << 'FILTER_EOF'
[Definition]
failregex = ^<HOST> .* "POST /login HTTP/.*" 401
            ^<HOST> .* "POST /admin HTTP/.*" 401
            ^<HOST> .* "POST /panel HTTP/.*" 401
            ^<HOST> .* "GET /wp-admin HTTP/.*" 401
            ^<HOST> .* "POST /xmlrpc.php HTTP/.*"
            ^<HOST> .* "POST /wp-login.php HTTP/.*"
            ^<HOST> .* "GET /config/.* HTTP/.*" 404
            ^<HOST> .* "GET /.env HTTP/.*" 404
            ^<HOST> .* "GET /admin/.* HTTP/.*" 403
            ^<HOST> .* "POST /api/.* HTTP/.*" 429
            ^<HOST> .* "GET /sql/.* HTTP/.*"
            ^<HOST> .* "GET /backup/.* HTTP/.*"
            ^<HOST> .* "POST /upload/.* HTTP/.*" 413
          ... (7 KB left)
