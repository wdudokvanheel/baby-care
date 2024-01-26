package com.bitechular.babycare.configuration.spring.resolver;

import com.bitechular.babycare.api.dto.babyaction.ActionUpdateRequest;
import com.bitechular.babycare.api.mapper.BabyActionUpdateRequestDeserializer;
import com.bitechular.babycare.data.model.BabyAction;
import com.bitechular.babycare.data.model.BabyActionType;
import com.bitechular.babycare.service.BabyActionService;
import com.bitechular.babycare.service.exception.EntityNotFoundException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.module.SimpleModule;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.core.MethodParameter;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;
import org.springframework.web.servlet.HandlerMapping;

import java.io.InputStream;
import java.util.Map;

/**
 * When the BabyAction update endpoint is called, the request does not contain any type information for the BabyAction.
 * In order to correctly convert the request body to an instance of ActionUpdateRequest (or a subclass), the action
 * is first retrieved and the correct implementation of ActionUpdateRequest is selected based on the action's type and
 * use of the ActionMapperService
 */

@Service
public class UpdateActionRequestBodyArgumentResolver implements HandlerMethodArgumentResolver {
    private Logger logger = LoggerFactory.getLogger(UpdateActionRequestBodyArgumentResolver.class);

    private final ApplicationContext applicationContext;
    private BabyActionService actionService;

    public UpdateActionRequestBodyArgumentResolver(ApplicationContext applicationContext, BabyActionService actionService) {
        this.applicationContext = applicationContext;
        this.actionService = actionService;
    }

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return parameter.hasParameterAnnotation(UpdateActionRequestBody.class);
    }

    @Override
    public Object resolveArgument(MethodParameter parameter,
                                  ModelAndViewContainer mavContainer,
                                  NativeWebRequest webRequest,
                                  WebDataBinderFactory binderFactory) throws Exception {
        HttpServletRequest httpServletRequest = webRequest.getNativeRequest(HttpServletRequest.class);
        Map<String, String> attribute = (Map<String, String>) httpServletRequest.getAttribute(HandlerMapping.URI_TEMPLATE_VARIABLES_ATTRIBUTE);

        BabyActionType type;

        try {
            // Parse ID value from the request path
            long id = Long.valueOf(attribute.get("id"));
            if (id <= 0) {
                return null;
            }

            // Find the action
            BabyAction action = actionService.getById(id);
            if (action == null) {
                logger.error("Action type not set for action #{}", id);
                throw new EntityNotFoundException("Action", id);
            }
            type = action.getType();
        } catch (NumberFormatException e) {
            logger.error("Failed to parse ID number for update action: {}", attribute.get("id"));
            return null;
        }

        BabyActionUpdateRequestDeserializer deserializer = applicationContext.getBean(BabyActionUpdateRequestDeserializer.class);
        deserializer.setType(type);

        SimpleModule module = new SimpleModule();
        module.addDeserializer(ActionUpdateRequest.class, deserializer);
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.registerModule(module);

        InputStream inputStream = webRequest.getNativeRequest(HttpServletRequest.class).getInputStream();
        return objectMapper.readValue(inputStream, parameter.getParameterType());
    }
}
