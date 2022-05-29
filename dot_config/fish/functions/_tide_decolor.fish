function _tide_decolor
    string replace --all -r '\e(\[[\d;]*|\(B\e\[)m(\co)?' '' "$argv"
end
