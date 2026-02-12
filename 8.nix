# ============================================================================
#   ___  _   ___   ____  __    ___
#  / _ \| \ | \ \ / /\ \/ /   ( _ )
# | | | |  \| |\ V /  \  /    / _ \
# | |_| | |\  | | |   /  \   | (_) |
#  \___/|_| \_| |_|  /_/\_\   \___/
#
# The Spider - Red Team Arsenal
# "The Phantom Troupe's strength lies in its members."
# ============================================================================
#
# USAGE: Import this file in your configuration.nix
#   imports = [ ./8.nix ];
#
# ============================================================================

{ config, pkgs, lib, ... }:

let
  # Python environment with security packages
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    # Core
    requests
    httpx
    aiohttp
    urllib3

    # Parsing
    beautifulsoup4
    lxml
    html5lib

    # Exploitation
    pwntools
    impacket
    scapy
    paramiko
    pycryptodome
    cryptography

    # Data handling
    pandas
    numpy

    # Web
    flask
    werkzeug

    # DNS/Network
    dnspython
    ipython
    netaddr

    # Misc
    colorama
    tqdm
    pyyaml
    toml
    rich
    typer
    click
  ]);

in
{
  # Allow unfree packages (required for some security tools)
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [

    # =========================================================================
    # LEG 1: RECONNAISSANCE & OSINT
    # =========================================================================

    # --- Port/Network Scanning ---
    nmap                      # The classic
    masscan                   # Fast port scanner
    rustscan                  # Modern fast scanner
    zmap                      # Internet-wide scanner

    # --- DNS Enumeration ---
    dnsrecon                  # DNS enumeration
    dnsenum                   # DNS bruteforce
    fierce                    # DNS reconnaissance
    amass                     # Attack surface mapping
    subfinder                 # Passive subdomain discovery
    dnsx                      # Fast DNS toolkit

    # --- OSINT ---
    theharvester              # Email/domain harvester
    sherlock                  # Username hunter
    maltego                   # Link analysis (GUI)
    recon-ng                  # Recon framework
    holehe                    # Email to accounts

    # --- Web Discovery ---
    gobuster                  # Directory bruteforce
    ffuf                      # Fast fuzzer
    feroxbuster               # Recursive discovery
    dirb                      # Web content scanner
    dirbuster                 # Directory bruteforce (GUI)
    httpx                     # HTTP toolkit
    katana                    # Web crawler
    hakrawler                 # Web crawler
    gau                       # URLs from AlienVault/Wayback
    waybackurls               # Wayback machine URLs

    # --- Git/Code Recon ---
    trufflehog                # Secrets in git
    gitleaks                  # Git secret scanner
    git-secrets               # Prevent secret commits

    # --- Infrastructure ---
    whatweb                   # Web fingerprinting

    # =========================================================================
    # LEG 2: NETWORK ATTACKS
    # =========================================================================

    # --- Sniffing/MITM ---
    wireshark                 # Packet analysis (GUI)
    tshark                    # CLI packet analysis
    termshark                 # TUI packet analysis
    tcpdump                   # Packet capture
    ettercap                  # MITM framework
    bettercap                 # Network attack toolkit
    arpwatch                  # ARP monitoring
    mitmproxy                 # HTTP/S proxy

    # --- Network Utilities ---
    netcat-gnu                # Network swiss army knife
    socat                     # Advanced netcat
    ncat                      # Nmap's netcat
    hping                     # Packet crafting
    arping                    # ARP ping

    # --- Tunneling/Pivoting ---
    proxychains-ng            # Proxy chains
    chisel                    # TCP/UDP tunneling
    sshuttle                  # VPN over SSH

    # --- DNS Attacks ---
    responder                 # LLMNR/NBT-NS poisoner
    dnschef                   # DNS proxy

    # --- SMB/Windows ---
    samba                     # SMB client/server
    enum4linux                # SMB enumeration
    enum4linux-ng             # Modern enum4linux
    crackmapexec              # Swiss army knife for Windows
    smbmap                    # SMB enumeration

    # --- LDAP/AD ---
    openldap                  # LDAP tools
    ldapdomaindump            # AD info dumper

    # --- MAC/ARP ---
    macchanger                # MAC spoofing

    # =========================================================================
    # LEG 3: WIRELESS & RF
    # =========================================================================

    # --- WiFi ---
    aircrack-ng               # WiFi cracking suite
    wifite2                   # Automated WiFi attacks
    reaverwps-t6x             # WPS attacks (modern fork)
    bully                     # WPS bruteforce
    cowpatty                  # WPA-PSK audit
    pixiewps                  # WPS pixie dust
    hcxtools                  # WiFi capture conversion
    hcxdumptool               # WiFi capture tool

    # --- Bluetooth ---
    bluez                     # Bluetooth stack
    bluez-tools               # Bluetooth utilities

    # --- SDR (Software Defined Radio) ---
    gnuradio                  # SDR framework
    gqrx                      # SDR receiver
    rtl-sdr                   # RTL-SDR drivers
    hackrf                    # HackRF tools

    # =========================================================================
    # LEG 4: WEB APPLICATION
    # =========================================================================

    # --- Vulnerability Scanners ---
    nikto                     # Web server scanner
    wpscan                    # WordPress scanner
    nuclei                    # Template-based scanner

    # --- SQL Injection ---
    sqlmap                    # SQL injection

    # --- XSS ---
    dalfox                    # XSS scanner

    # --- Fuzzing ---
    wfuzz                     # Web fuzzer

    # --- Proxies ---
    burpsuite                 # Web proxy (GUI)
    zap                       # OWASP ZAP

    # --- API Testing ---
    postman                   # API client
    insomnia                  # API client

    # --- CMS ---
    joomscan                  # Joomla

    # --- SSL/TLS ---
    sslscan                   # SSL scanner
    sslyze                    # SSL analysis
    testssl                   # SSL testing

    # =========================================================================
    # LEG 5: EXPLOITATION
    # =========================================================================

    # --- Frameworks ---
    metasploit                # MSF
    exploitdb                 # Exploit database

    # --- Payload Generation ---
    msfpc                     # MSFvenom payload creator

    # --- Binary Exploitation ---
    radare2                   # RE framework
    gef                       # GDB enhanced features
    one_gadget                # One gadget finder
    checksec                  # Binary security check
    pwntools                  # CTF toolkit
    pwninit                   # Pwn template generator

    # --- Shellcode ---
    nasm                      # Assembler
    yasm                      # Assembler

    # =========================================================================
    # LEG 6: POST-EXPLOITATION & C2
    # =========================================================================

    # --- C2 Frameworks ---
    havoc                     # C2 framework

    # --- Credential Dumping ---
    mimikatz                  # Windows creds (wine)

    # --- Windows Post-Ex ---
    evil-winrm                # WinRM shell
    bloodhound                # AD attack paths
    bloodhound-py             # BloodHound ingestor

    # --- Impacket tools (via Python) ---
    # impacket included in pythonEnv

    # =========================================================================
    # LEG 7: FORENSICS & IR
    # =========================================================================

    # --- Disk Forensics ---
    sleuthkit                 # Filesystem forensics
    autopsy                   # Forensic browser
    testdisk                  # Data recovery
    ddrescue                  # Data recovery

    # --- Memory Forensics ---
    volatility3               # Memory analysis

    # --- Network Forensics ---
    # wireshark already listed
    networkminer              # Network forensics
    zeek                      # Network analysis

    # --- File Analysis ---
    binwalk                   # Firmware analysis
    foremost                  # File carving
    scalpel                   # File carving
    exiftool                  # Metadata
    oletools                  # Office analysis

    # --- Log Analysis ---
    lnav                      # Log navigator

    # --- Malware Analysis ---
    yara                      # Pattern matching
    clamav                    # Antivirus

    # =========================================================================
    # LEG 8: REVERSE ENGINEERING
    # =========================================================================

    # --- Disassemblers/Decompilers ---
    ghidra                    # NSA RE tool
    # radare2 already listed
    rizin                     # Radare2 fork
    cutter                    # Rizin GUI
    iaito                     # Radare2 GUI

    # --- Debuggers ---
    gdb                       # GNU debugger
    # gef already listed
    lldb                      # LLVM debugger
    strace                    # System call tracer
    ltrace                    # Library call tracer

    # --- Binary Analysis ---
    binutils                  # Binary tools
    elfutils                  # ELF tools
    patchelf                  # ELF patcher
    upx                       # Packer/unpacker

    # --- .NET/Java ---
    jadx                      # Java decompiler
    cfr                       # Java decompiler

    # --- Android ---
    apktool                   # APK RE
    androguard                # Android analysis

    # =========================================================================
    # HARDWARE HACKING
    # =========================================================================

    # --- Flash/BIOS ---
    flashrom                  # BIOS/firmware flasher

    # --- Serial/Debug ---
    minicom                   # Serial terminal
    screen                    # Serial terminal
    picocom                   # Serial terminal

    # --- Logic Analysis ---
    sigrok-cli                # Signal analysis
    pulseview                 # Logic analyzer GUI

    # --- JTAG/SWD ---
    openocd                   # Debug interface

    # --- USB ---
    usbutils                  # USB utilities

    # =========================================================================
    # CRYPTOGRAPHY & PASSWORDS
    # =========================================================================

    # --- Password Cracking ---
    hashcat                   # GPU cracker
    john                      # John the Ripper
    thc-hydra                 # Online cracker
    medusa                    # Online cracker
    ncrack                    # Network auth cracker

    # --- Hash Identification ---
    hashid                    # Hash identifier
    hash-identifier           # Hash identifier

    # --- Wordlists ---
    wordlists                 # Common wordlists
    seclists                  # Security lists

    # --- Crypto Tools ---
    openssl                   # SSL/crypto toolkit
    gnupg                     # GPG
    age                       # Modern encryption

    # =========================================================================
    # REPORTING & DOCUMENTATION
    # =========================================================================

    # --- Screenshots ---
    flameshot                 # Screenshot tool

    # --- Notes ---
    obsidian                  # Knowledge base
    cherrytree                # Hierarchical notes

    # --- Reporting ---
    pandoc                    # Document converter

    # --- Diagrams ---
    drawio                    # Diagramming

    # =========================================================================
    # GENERAL UTILITIES
    # =========================================================================

    # --- Editors ---
    helix                     # Modern editor
    neovim                    # Vim but better
    vscode                    # GUI editor

    # --- Terminal ---
    tmux                      # Terminal multiplexer
    zellij                    # Modern tmux

    # --- Shell ---
    zsh                       # Z shell
    starship                  # Shell prompt
    fzf                       # Fuzzy finder
    ripgrep                   # Fast grep
    fd                        # Fast find
    bat                       # Better cat
    eza                       # Better ls
    zoxide                    # Smart cd

    # --- HTTP Clients ---
    curl
    wget
    httpie
    xh                        # Modern httpie

    # --- Data Processing ---
    jq                        # JSON
    yq                        # YAML
    htmlq                     # HTML

    # --- Containers ---
    docker
    docker-compose
    podman

    # --- VMs ---
    qemu
    virt-manager

    # --- Networking ---
    openvpn
    wireguard-tools

    # --- Version Control ---
    git
    gh                        # GitHub CLI

    # --- Compilers/Runtime ---
    pythonEnv                 # Python with security packages
    ruby
    go
    rustc
    cargo
    nodejs

    # --- Archives ---
    p7zip
    unzip
    unrar
    gzip
    xz

  ];

  # ===========================================================================
  # SYSTEM CONFIGURATION
  # ===========================================================================

  # Enable Wireshark for non-root
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  # Enable ADB for Android testing
  programs.adb.enable = true;

  # Virtualisation
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  # Podman as alternative
  virtualisation.podman.enable = true;

  # ===========================================================================
  # SERVICES
  # ===========================================================================

  # PostgreSQL for Metasploit
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "msf" ];
    ensureUsers = [{
      name = "msf";
      ensureDBOwnership = true;
    }];
  };

  # ===========================================================================
  # NETWORKING
  # ===========================================================================

  # Useful for testing
  networking.firewall.enable = lib.mkDefault true;

  # ===========================================================================
  # SHELL ALIASES
  # ===========================================================================

  programs.bash.shellAliases = {
    # Nmap
    nse = "ls /run/current-system/sw/share/nmap/scripts/";

    # Quick servers
    serve = "python3 -m http.server";

    # Listeners
    listen = "nc -lvnp";

    # MSF
    msfconsole = "msfconsole -q";

    # IP
    myip = "curl -s ifconfig.me";
    localip = "ip -4 addr show | grep -oP '(?<=inet\\s)\\d+(\\.\\d+){3}'";
  };

  # ===========================================================================
  # ENVIRONMENT
  # ===========================================================================

  environment.variables = {
    # Wordlists
    WORDLISTS = "${pkgs.wordlists}/share/wordlists";
    SECLISTS = "${pkgs.seclists}/share/seclists";
    ROCKYOU = "${pkgs.wordlists}/share/wordlists/rockyou.txt";
  };
}
