#!/bin/bash
set -euo pipefail

# ============================================================================
# TigerOS Welcome - Build Script
# ============================================================================
# Usage:
#   ./build-tiger-welcome.sh          # Build only
#   ./build-tiger-welcome.sh run      # Build and run
#   ./build-tiger-welcome.sh clean    # Clean build files
#   ./build-tiger-welcome.sh package  # Build and create .deb package
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
PROJECT_NAME="tiger-welcome"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# ============================================================================
# Check dependencies
# ============================================================================
check_deps() {
    log_info "Verificando dependências..."
    
    local missing=()
    
    # Check for qmake6 or cmake
    if ! command -v qmake6 &> /dev/null && ! command -v cmake &> /dev/null; then
        missing+=("qt6-base-dev ou cmake")
    fi
    
    if ! command -v g++ &> /dev/null; then
        missing+=("g++ (build-essential)")
    fi
    
    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Dependências faltando: ${missing[*]}"
        echo ""
        echo "Instale com:"
        echo "  sudo apt install qt6-base-dev qt6-declarative-dev qt6-5compat-dev"
        echo "  sudo apt install build-essential libkf6kirigami2-dev"
        echo ""
        exit 1
    fi
    
    log_success "Dependências OK"
}

# ============================================================================
# Build using qmake
# ============================================================================
build_qmake() {
    log_info "Compilando com qmake6..."
    
    mkdir -p "${BUILD_DIR}"
    cd "${BUILD_DIR}"
    
    # Run qmake
    if command -v qmake6 &> /dev/null; then
        qmake6 "${SCRIPT_DIR}/tiger-welcome.pro" -spec linux-g++ CONFIG+=release
    else
        qmake "${SCRIPT_DIR}/tiger-welcome.pro" -spec linux-g++ CONFIG+=release
    fi
    
    # Build
    make -j$(nproc)
    
    if [ -f "${BUILD_DIR}/${PROJECT_NAME}" ]; then
        log_success "Build completo: ${BUILD_DIR}/${PROJECT_NAME}"
    else
        log_error "Falha no build!"
        exit 1
    fi
}

# ============================================================================
# Build using CMake (alternative)
# ============================================================================
build_cmake() {
    log_info "Compilando com CMake..."
    
    mkdir -p "${BUILD_DIR}"
    cd "${BUILD_DIR}"
    
    cmake "${SCRIPT_DIR}" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr
    
    cmake --build . --parallel $(nproc)
    
    if [ -f "${BUILD_DIR}/${PROJECT_NAME}" ]; then
        log_success "Build completo: ${BUILD_DIR}/${PROJECT_NAME}"
    else
        log_error "Falha no build!"
        exit 1
    fi
}

# ============================================================================
# Clean build
# ============================================================================
clean_build() {
    log_info "Limpando arquivos de build..."
    rm -rf "${BUILD_DIR}"
    rm -f "${SCRIPT_DIR}/Makefile"
    rm -f "${SCRIPT_DIR}/.qmake.stash"
    rm -f "${SCRIPT_DIR}/${PROJECT_NAME}"
    log_success "Limpo!"
}

# ============================================================================
# Run the application
# ============================================================================
run_app() {
    if [ ! -f "${BUILD_DIR}/${PROJECT_NAME}" ]; then
        log_warn "Aplicativo não encontrado. Compilando primeiro..."
        build_qmake
    fi
    
    log_info "Executando ${PROJECT_NAME}..."
    
    # Set QML import path
    export QML_IMPORT_PATH="${SCRIPT_DIR}/qml"
    
    # Run
    cd "${BUILD_DIR}"
    ./${PROJECT_NAME}
}

# ============================================================================
# Create .deb package
# ============================================================================
create_package() {
    log_info "Criando pacote .deb..."
    
    if [ ! -f "${BUILD_DIR}/${PROJECT_NAME}" ]; then
        build_qmake
    fi
    
    local PKG_DIR="${BUILD_DIR}/pkg"
    local VERSION=$(date +%y.%m.%d)
    
    mkdir -p "${PKG_DIR}/DEBIAN"
    mkdir -p "${PKG_DIR}/usr/bin"
    mkdir -p "${PKG_DIR}/usr/share/applications"
    mkdir -p "${PKG_DIR}/usr/share/icons/hicolor/scalable/apps"
    mkdir -p "${PKG_DIR}/etc/skel/.config/autostart"
    
    # Copy binary
    cp "${BUILD_DIR}/${PROJECT_NAME}" "${PKG_DIR}/usr/bin/"
    chmod +x "${PKG_DIR}/usr/bin/${PROJECT_NAME}"
    
    # Copy desktop file
    cp "${SCRIPT_DIR}/tiger-welcome.desktop" "${PKG_DIR}/usr/share/applications/"
    cp "${SCRIPT_DIR}/tiger-welcome.desktop" "${PKG_DIR}/etc/skel/.config/autostart/"
    
    # Copy icon (if exists)
    if [ -f "${SCRIPT_DIR}/Imgs/Logos/tigeros-welcome.svg" ]; then
        cp "${SCRIPT_DIR}/Imgs/Logos/tigeros-welcome.svg" \
           "${PKG_DIR}/usr/share/icons/hicolor/scalable/apps/"
    fi
    
    # Create control file
    cat > "${PKG_DIR}/DEBIAN/control" <<EOF
Package: tiger-welcome
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: amd64
Depends: qt6-base-abi, qt6-declarative-abi, libkf6kirigami2-6
Maintainer: TigerOS Team <team@tigeros.com.br>
Description: TigerOS Welcome Application
 A modern glassmorphic welcome application for TigerOS.
 Helps new users configure and explore their system.
EOF
    
    # Build package
    dpkg-deb --build "${PKG_DIR}" "${BUILD_DIR}/${PROJECT_NAME}_${VERSION}_amd64.deb"
    
    log_success "Pacote criado: ${BUILD_DIR}/${PROJECT_NAME}_${VERSION}_amd64.deb"
}

# ============================================================================
# Main
# ============================================================================
main() {
    cd "${SCRIPT_DIR}"
    
    case "${1:-build}" in
        clean)
            clean_build
            ;;
        run)
            check_deps
            build_qmake
            run_app
            ;;
        package)
            check_deps
            build_qmake
            create_package
            ;;
        cmake)
            check_deps
            build_cmake
            ;;
        build|*)
            check_deps
            build_qmake
            ;;
    esac
}

main "$@"
