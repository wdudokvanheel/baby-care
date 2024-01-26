package com.bitechular.babycare.api.mapper;

import com.bitechular.babycare.api.dto.babyaction.ActionUpdateRequest;
import com.bitechular.babycare.api.mapper.action.ActionMapper;
import com.bitechular.babycare.data.model.BabyActionType;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
@Scope("prototype")
public class BabyActionUpdateRequestDeserializer extends JsonDeserializer<ActionUpdateRequest> {
    private Logger logger = LoggerFactory.getLogger(BabyActionUpdateRequestDeserializer.class);

    private ActionMapper mappers;
    private BabyActionType type;

    public BabyActionUpdateRequestDeserializer(ActionMapper mappers) {
        this.mappers = mappers;
    }

    public void setType(BabyActionType type) {
        this.type = type;
    }

    @Override
    public ActionUpdateRequest deserialize(JsonParser parser, DeserializationContext context)
            throws IOException {
        /*
         * Create a new ObjectMapper here, as the default ObjectMapper will call this same function again to deserialize
         * the ActionUpdateRequest, resulting in an infinite loop
         */
        ObjectMapper mapper = new ObjectMapper();
        mapper.configure(JsonParser.Feature.AUTO_CLOSE_SOURCE, true);
        return mapper.readValue(parser, mappers.getUpdateRequestType(type));
    }
}
