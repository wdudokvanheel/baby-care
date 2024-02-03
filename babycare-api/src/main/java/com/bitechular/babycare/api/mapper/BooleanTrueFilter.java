package com.bitechular.babycare.api.mapper;

public class BooleanTrueFilter {
    @Override
    public boolean equals(Object obj) {
        if (obj instanceof Boolean) {
            return !(Boolean) obj; // Only include if true, hence negating the boolean value
        }
        return false;
    }
}
