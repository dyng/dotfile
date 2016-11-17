tarepo() {
    git archive --format=tar $1 | gzip
}
