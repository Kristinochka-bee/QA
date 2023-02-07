package api.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter

public enum EndPoint {
    ADD_NEW_CONTACT ("/api/contact");
    private final String value; //constructor
}
