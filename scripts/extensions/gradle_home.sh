gradle_home() {
    if which gradle >/dev/null; then
        buildfile=${TMPDIR:-'/tmp'}'/get_gradle_home.gradle'

        if [[ ! -f $buildfile ]]; then
            cat > $buildfile <<-EOF
            task getHomeDir << {
                println gradle.gradleHomeDir
            }
EOF
        fi

        gradle -b $buildfile getHomeDir
    fi
}
