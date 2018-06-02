int NUM_COLUMNS = 15;

void main( void ) {
    float tileSize = u_size.x / float(NUM_COLUMNS);
    int NUM_ROWS = int(ceil(u_size.y / tileSize));
    
    int column = int(floor(gl_FragCoord.x / tileSize));
    int row = int(floor(gl_FragCoord.y / tileSize));
    
    vec2 pos = mod(gl_FragCoord.xy, vec2(tileSize)) - vec2(tileSize / 2.0);
    float individualTileAnimationDuration = u_total_animation_duration / 3.0;
    float animStartOffset = (float(NUM_ROWS - row) / float(NUM_ROWS)) * (u_total_animation_duration - individualTileAnimationDuration);
    float elapsedTileAnimTime = min(max(0.0, u_elapsed_time - animStartOffset), individualTileAnimationDuration);
    float tileRadius = (elapsedTileAnimTime / individualTileAnimationDuration) * (tileSize + 3.0);
  
    if (abs(pos.x) + abs(pos.y) < tileRadius - 3.0) {
        gl_FragColor = u_fill_colour;
    } else if (abs(pos.x) + abs(pos.y) < tileRadius) {
        gl_FragColor = u_border_colour;
    } else {
        gl_FragColor = SKDefaultShading();
    }
}
